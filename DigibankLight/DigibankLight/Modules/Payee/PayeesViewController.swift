//
//  PayeesViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
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
        setTitle("Payees")
        addBackButtonTarget(target: self, action: #selector(back))
    }
}


//MARK: - Actions
extension PayeesViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
}
