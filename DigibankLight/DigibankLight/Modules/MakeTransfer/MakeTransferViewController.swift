//
//  MakeTransferViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import UIKit

class MakeTransferViewController: BaseViewController {
        
    var onBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        setTitle("Transfer")
        addTarget(target: self, action: #selector(back))
    }
}

extension MakeTransferViewController {
    
}

extension MakeTransferViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
}
