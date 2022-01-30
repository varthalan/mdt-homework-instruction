//
//  PayeesViewController.swift
//  DigibankLight
//

import UIKit

class PayeesViewController: BaseViewController {
    
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
extension PayeesViewController {
    
    fileprivate func customizeParentSetup() {
        setTitle(PayeesViewModel.payeesTitle)
        addBackButtonTarget(target: self, action: #selector(back))
    }
}


//MARK: - Actions
extension PayeesViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
}
