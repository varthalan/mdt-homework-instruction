//
//  PayeesViewController.swift
//  DigibankLight
//

import UIKit

final class PayeesViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noPayeesLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.text = PayeesViewModel.zeroPayees
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

         
    private let viewModel: PayeesViewModel
    private var payees: [PayeesResponse.Payee]?
    private var selectedPayee: PayeesResponse.Payee?
    
    typealias Empty = () -> Void
    
    var onCancel: (Empty)?
    var onDone: ((String, String) -> Void)?
    var onJWTExpiry: (Empty)?
    
    init(viewModel: PayeesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        bindViewModelEvents()
        viewModel.loadPayees()
    }
}

//MARK: - Setup
extension PayeesViewController {
        
    private func setupUI() {
        customizeNavigationItem()
        
        setupTableView()
        setupNoPayeesLabel()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PayeeTableCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func customizeNavigationItem() {
        navigationItem.title = PayeesViewModel.payeesTitle
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = doneBarButtonItem

        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        cancelBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNoPayeesLabel() {
        view.addSubview(noPayeesLabel)

        NSLayoutConstraint.activate([
            noPayeesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noPayeesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            noPayeesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPayeesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        noPayeesLabel.isHidden = true
    }
}

//MARK: - ViewModel Events
extension PayeesViewController {
    
    private func bindViewModelEvents() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                isLoading ? self.startLoading() : self.stopLoading()
            }
        }
        
        viewModel.onError = {  [weak self] message, isSessionExpired in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
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
        
        viewModel.onPayees = { [weak self] payees in
            guard let self = self else { return }
            
            self.payees = payees
            
            DispatchQueue.main.async {
                self.tableView.isHidden = payees.isEmpty
                self.noPayeesLabel.isHidden = !payees.isEmpty
                
                if !payees.isEmpty {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - Actions
extension PayeesViewController {
    
    @objc func done(_ sender: AnyObject) {
        guard let payeeName = selectedPayee?.name,
              let payeeAccountNumber = selectedPayee?.accountNumber else {
                  onCancel?()
                  return
              }
              
        onDone?(payeeName, payeeAccountNumber)
    }
    
    @objc func cancel(_ sender: AnyObject) {
        onCancel?()
    }
}

//MARK: - UITableViewDataSource protocol implementation
extension PayeesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        payees?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PayeeTableCell") else {
            return UITableViewCell()
        }
        guard let payee = payees?[indexPath.row] else {
            return UITableViewCell()
        }
        if let selectedPayee = self.selectedPayee,
           payee == selectedPayee {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.selectionStyle = .none
        var content = cell.defaultContentConfiguration()
        content.text = payee.name
        content.secondaryText = payee.accountNumber
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - UITableViewDelegate protocol implementation
extension PayeesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPayee = payees?[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadData()
    }
}
