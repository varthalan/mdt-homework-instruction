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
        debugPrint("transactions.count + 1 - \(transactions.count + 1)")
        return transactions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.layer.cornerRadius = 30
        cell.clipsToBounds = true
        
        let (groupName, transactions) = viewModel.groupTransactions(at: indexPath.section)
        if indexPath.row == 0 {
            cell.textLabel?.text = groupName
        } else {
            let transaction = transactions[indexPath.row - 1]
            cell.textLabel?.text = transaction.accountName
        }
        return cell
    }
    
}
