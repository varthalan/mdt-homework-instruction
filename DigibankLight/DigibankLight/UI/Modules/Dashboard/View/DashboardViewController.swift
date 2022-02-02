//
//  DashboardViewController.swift
//  DigibankLight
//

import UIKit

final class DashboardViewController: UIViewController {
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private(set) var makeTransferButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var tableViewSectionHeader: UILabel = {
        let label = UILabel(frame: .init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44))
        label.textColor = .black
        label.text = DashboardViewModel.yourTransactionHistory
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var balanceView = BalanceView(frame: .init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 255.0))

    private let viewModel: DashboardViewModel
    
    typealias Observer<T> = (T) -> Void
    typealias Refresh = ((Bool) -> Void)
    typealias Empty = () -> Void

    var onLogout: (Empty)?
    var onMakeTransfer: (Observer<Refresh?>)?
    var onJWTExpiry: (Empty)?

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        setupUI()
        viewModel.loadDashboard()
    }
        
    private func setupUI() {
        setupLogoutButton()
        setupMakeTransferButton()
        setupTableView()
        setupRefreshControl()
        bindViewModelEvents()
        registerTableViewCells()
    }
}

//MARK: - Setup
extension DashboardViewController {
    
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 60.0),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            logoutButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        logoutButton.setTitle(DashboardViewModel.logoutButtonTitle, for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    func setupMakeTransferButton() {
        view.addSubview(makeTransferButton)
        NSLayoutConstraint.activate([
            makeTransferButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            makeTransferButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            makeTransferButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            makeTransferButton.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        makeTransferButton.setTitle(
            DashboardViewModel.makeTransferButtonTitle,
            for: .normal
        )
        makeTransferButton.decorate(
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 18, weight: .black),
            borderColor: .black,
            cornerRadius: 30.0,
            borderWidth: 1.0
        )        
        makeTransferButton.addTarget(
            self,
            action: #selector(makeTransfer),
            for: .touchUpInside
        )
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20.0),
            tableView.bottomAnchor.constraint(equalTo: makeTransferButton.topAnchor, constant: -20.0)
        ])
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupRefreshControl() {
        let refreshControler = UIRefreshControl()
        refreshControler.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged)
        tableView.refreshControl = refreshControler
    }
    
    private func registerTableViewCells() {
        tableView.register(
            TransactionTableViewCell.self,
            forCellReuseIdentifier: "TransactionTableViewCell"
        )
        tableView.register(
            TransacationsGroupTableViewCell.self,
            forCellReuseIdentifier: "TransacationsGroupTableViewCell"
        )
    }

    private func setupTableViewHeader() {
        if tableView.tableHeaderView == nil {
            tableView.tableHeaderView = balanceView
        }
    }
}

//MARK: - ViewModel Events
extension DashboardViewController {
    
    private func bindViewModelEvents() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if !(self.tableView.refreshControl?.isRefreshing ?? false) {
                    isLoading ? self.startLoading() : self.stopLoading()
                }
            }
        }
        
        viewModel.onError = {  [weak self] message, isSessionExpired in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                if isSessionExpired {
                    self.showError(message: "session expired", showOnTop: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.onJWTExpiry?()
                    }
                } else {
                    self.showError(message: message)
                }
            }
        }
        
        viewModel.onDashboardLoad = { [weak self] in
            guard let self = self,
                  let balance = self.viewModel.balance else { return }
                        
            DispatchQueue.main.async {
                self.setupTableViewHeader()
                
                self.balanceView.balanceLabel.text = balance.accountBalance
                self.balanceView.accountNumberValueLabel.text = balance.accountNumber
                self.balanceView.accountHolderValueLabel.text = balance.accountHolder
                
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Actions
extension DashboardViewController {
    
    @objc func logout(_ sender: AnyObject) {
        onLogout?()
    }
    
    @objc func makeTransfer(_ sender: AnyObject) {
        onMakeTransfer?() { [weak self] isRefreshNeeded in
            guard let self = self,
                  let refreshControl = self.tableView.refreshControl else { return }
            
            if isRefreshNeeded {
                self.refresh(refreshControl)
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.loadDashboard()
    }
}

//MARK: - UITableViewDataSource Protocol Implementation
extension DashboardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (_, transactions) = viewModel.groupTransactions(at:section)
        return transactions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (groupName, transactions) = viewModel.groupTransactions(at: indexPath.section)
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransacationsGroupTableViewCell") as? TransacationsGroupTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.groupNameLabel.text = groupName
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as? TransactionTableViewCell else {
                return UITableViewCell()
            }
            let transaction = transactions[indexPath.row - 1]
            guard let amount = viewModel.convertAmount(transaction.amount),
                  let type = transaction.transactionType else {
                      return UITableViewCell()
                  }
                       
            cell.selectionStyle = .none
            cell.accountNameLabel.text = transaction.accountName
            cell.accountNumberLabel.text = transaction.accountNumber
            let transactionMode = transactionType(amount, transactionType: type)
            cell.amountLabel.text = transactionMode.amount
            cell.amountLabel.textColor = transactionMode.color
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? tableViewSectionHeader : nil
    }
        
    private func transactionType(_ amount: String, transactionType: String) -> (amount: String, color: UIColor) {
        if transactionType == "received" {
            return (amount, .systemGreen)
        }
        
        return ("-" + amount, .systemGray)
    }
    
}

//MARK: - UITableViewDelegate protocol implementations
extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 64 : 0.0
    }
}
