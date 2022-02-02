//
//  PayeesViewModel.swift
//  DigibankLight
//

import Foundation

final class PayeesViewModel {
    private let service: PayeesService
    private let jwtToken: String
    
    typealias Observer<T> = (T) -> Void
    
    var onLoadingStateChange: Observer<Bool>?
    var onPayees: Observer<[PayeesResponse.Payee]>?
    var onError: ((String, Bool) -> Void)?
    
    init(service: PayeesService, jwtToken: String) {
        self.service = service
        self.jwtToken = jwtToken
    }

    func loadPayees() {
        onLoadingStateChange?(true)
        service.load(jwtToken: jwtToken) { [weak self] result in
            
            guard let self = self else { return }
            self.onLoadingStateChange?(false)
            
            switch result {
            case let .success(response):
                if let error = response.error,
                   let message = error.message,
                   let name = error.name {
                    self.onError?(message, Utitlies.isSessionExpiredMessage(name))
                } else {
                    self.onPayees?(response.payees ?? [])
                }
                    
            case let .failure(error):
                self.onError?(error.localizedDescription, false)
            }
        }
    }
}

//MARK: - Strings
extension PayeesViewModel {
    
    static var payeesTitle: String {
        localize("payees_title")
    }
}
