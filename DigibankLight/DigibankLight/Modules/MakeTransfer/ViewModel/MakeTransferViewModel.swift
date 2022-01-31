//
//  MakeTransferViewModel.swift
//  DigibankLight
//

import Foundation

final class MakeTransferViewModel {
    init() {}
}

//MARK: - Strings
extension MakeTransferViewModel {
    
    static var transferTitle: String {
        localize("transfer_title")
    }

    static var payeeFieldTitle: String {
        localize("payee_field_title")
    }

    static var amountFieldTitle: String {
        localize("amount_field_title")
    }

    static var descriptionFieldTitle: String {
        localize("description_field_title")
    }
    
    static var transferNowButtonTitle: String {
        localize("transfer_now_button_title")
    }
    
    static var payeeFieldFeedback: String {
        localize("payee_required")
    }
        
    static var amountFieldFeedback: String {
        localize("amount_required")
    }
}
