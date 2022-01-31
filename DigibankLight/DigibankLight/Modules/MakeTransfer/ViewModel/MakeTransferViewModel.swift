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
    var onError: Observer<String>?
    
    init(service: MakeTransferService, jwtToken: String) {
        self.service = service
        self.jwtToken = jwtToken
    }
    
    func makeTransfer() {
        onLoadingStateChange?(true)
        service.transfer(jwtToken: jwtToken) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoadingStateChange?(false)
            
            switch result {
            case let .success(response):
                self.onTransfer?(response)
                
            case let .failure(error):
                self.onError?(error.localizedDescription)
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
}
