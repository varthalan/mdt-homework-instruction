//
//  DashboardViewController.swift
//  DigibankLight
//

import UIKit

class DashboardViewController: BaseViewController {
    
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


    private let viewModel: DashboardViewModel
    
    var onLogout: (() -> Void)?
    var onMakeTransfer: (() -> Void)?

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel.loadDashboard()
    }
    
    override func setupUI() {
        super.setupUI()
       
        customizeParent()
        setupLogoutButton()
        setupTableView()
        setupRefreshControl()
        bindViewModelEvents()
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.register(TransacationsGroupTableViewCell.self, forCellReuseIdentifier: "TransacationsGroupTableViewCell")
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
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20.0),
            tableView.bottomAnchor.constraint(equalTo: bottomActionButton.topAnchor, constant: -20.0)
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
}

//MARK: - Customizations
extension DashboardViewController {
    
    private func customizeParent() {
        setTitleHidden(true)
        setBackButtonHidden(true)
        
        configureBottomActionButtonWith(
            title: DashboardViewModel.makeTransferButtonTitle,
            target: self,
            action: #selector(makeTransfer)
        )
    }
}

//MARK: - ViewModel Events

extension DashboardViewController {
    
    private func bindViewModelEvents() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                isLoading ? self.startLoading() : self.stopLoading()
            }
        }
        
        viewModel.onError = {  [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.onDashboardLoad = { [weak self] in
            guard let self = self else { return }
                        
            DispatchQueue.main.async {
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
        onMakeTransfer?()
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Your transaction history"
        }
        return nil
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
        section == 0 ? 84 : 0.0
    }
}
