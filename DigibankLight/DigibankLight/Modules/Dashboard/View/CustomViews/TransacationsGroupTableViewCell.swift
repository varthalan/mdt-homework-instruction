//
//  TransacationsGroupTableViewCell.swift
//  DigibankLight
//

import UIKit

class TransacationsGroupTableViewCell: UITableViewCell {
    
    private(set) var groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = .gray
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

extension TransacationsGroupTableViewCell {
    
    private func setupUI() {
        setupAccountNameLabel()
    }
    
    private func setupAccountNameLabel() {
        contentView.addSubview(groupNameLabel)
        NSLayoutConstraint.activate([
            groupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            groupNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            groupNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            groupNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4.0)
        ])
    }
}
