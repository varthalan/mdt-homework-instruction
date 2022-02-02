//
//  TransactionTableViewCell.swift
//  DigibankLight
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    private(set) var accountNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var accountNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension TransactionTableViewCell {
    
    private func setupUI() {
        setupAccountNameLabel()
        setupAccountNumberLabel()
        setupAmountLabel()
    }
    
    private func setupAccountNameLabel() {
        contentView.addSubview(accountNameLabel)
        NSLayoutConstraint.activate([
            accountNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            accountNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -64.0),
            accountNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            accountNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6, constant: -8.0)
        ])
    }

    private func setupAccountNumberLabel() {
        contentView.addSubview(accountNumberLabel)
        NSLayoutConstraint.activate([
            accountNumberLabel.leadingAnchor.constraint(equalTo: accountNameLabel.leadingAnchor),
            accountNumberLabel.widthAnchor.constraint(equalToConstant: 120.0),
            accountNumberLabel.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor),
            accountNumberLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4, constant: -8.0)
        ])
    }

    private func setupAmountLabel() {
        contentView.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            amountLabel.leadingAnchor.constraint(equalTo: accountNameLabel.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: accountNameLabel.centerYAnchor),
            amountLabel.heightAnchor.constraint(equalTo: accountNameLabel.heightAnchor)
        ])
    }
}
