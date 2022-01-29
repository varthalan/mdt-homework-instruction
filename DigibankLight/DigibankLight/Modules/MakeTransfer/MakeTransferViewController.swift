//
//  MakeTransferViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import UIKit

class MakeTransferViewController: BaseViewController {
        
    private let transferNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        
        customizeParentSetup()
    }
}

//MARK: - Customization
extension MakeTransferViewController {
    
    fileprivate func customizeParentSetup() {
        setTitle("Transfer")
        configureBottomActionButtonWith(
            title: "Transfer Now",
            target: self,
            action: #selector(transfer)
        )
        addBackButtonTarget(target: self, action: #selector(back))
    }    
}

//MARK: - Actions
extension MakeTransferViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
    
    @objc func transfer(_ sender: AnyObject) {
        //API call
    }
    
}
