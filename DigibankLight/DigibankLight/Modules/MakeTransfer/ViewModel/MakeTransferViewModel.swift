//
//  MakeTransferViewModel.swift
//  DigibankLight
//

import Foundation

final class MakeTransferViewModel {
    private let service: MakeTransferService
    private let jwtToken: String
    
    typealias Observer<T> = (T) -> Void
    
    var onLoadingStateChange: Observer<Bool>?
    var onTransfer: Observer<MakeTransferResponse>?
    var onError: ((String, Bool) -> Void)?
    
    init(service: MakeTransferService, jwtToken: String) {
        self.service = service
        self.jwtToken = jwtToken
    }
    
    func makeTransfer(
        accountNumber: String,
        amount: String,
        description: String? = nil) {
            guard let amountAsDouble = Double(amount) else {
                self.onError?("Amount must be an integer", false)
                return
            }
            
            onLoadingStateChange?(true)
            service.transfer(
            accountNumber: accountNumber,
            amount: amountAsDouble,
            description: description,
            jwtToken: jwtToken) { [weak self] result in
                
                guard let self = self else { return }
                                
                self.onLoadingStateChange?(false)
                
                switch result {
                case let .success(response):
                    if let errorMessage = response.errorMessage {
                        self.onError?(errorMessage, false)
                    } else if let errorMessage = response.error?.message,
                              let errorName = response.error?.name {
                        self.onError?(errorMessage, Utitlies.isSessionExpiredMessage(errorName))
                    } else {
                        self.onTransfer?(response)
                    }
                    
                case let .failure(error):
                    self.onError?(error.localizedDescription, false)
                }
                
            }
        }
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
    
    static var successfulTransferAlertTitle: String {
        localize("successful_transfer_alert_title")
    }
    
    static var successfulTransferAlertMessage: String {
        localize("successful_transfer_alert_message")
    }
    
    static var makeTransferActionTitle: String {
        localize("make_transfer_action_title")
    }
    
    static var gotoDashboardActionTitle: String {
        localize("goto_dashboard_action_title")
    }
}
