//
//  TransactionsServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

struct TransactionsResponse: Equatable {
    
    struct Transaction: Equatable {
        let transactionId: String?
        let amount: Int?
        let transactionDate: Date?
        let description: String?
        let transactionType: String?
        let accountNumber: String?
        let accountName: String?
    }
    
    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiredDate: String?
    }
    
    let status: String
    let transactions: [Transaction]?
    let error: Error?
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.date(from: self)
    }
}


final class TransactionsServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Transaction: Decodable {
            
            struct Receipient: Decodable {
                let accountNo: String?
                let accountHolder: String?
            }
            
            struct Sender: Decodable {
                let accountNo: String?
                let accountHolder: String?
            }
            
            let transactionId: String?
            let amount: Int?
            let transactionDate: String?
            let description: String?
            let transactionType: String?
            let receipient: Receipient?
            let sender: Sender?
        }
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private let status: String
        private let data: [Transaction]?
        private let error: Error?
        
        var transactionsResponse: TransactionsResponse {
            let transactions = data?.map({ transaction -> TransactionsResponse.Transaction in
                let transactionType = transaction.transactionType
                var accountNumber: String?
                var accountName: String?
                if transactionType != nil && transactionType! == "transfer" {
                    accountNumber = transaction.receipient?.accountNo
                    accountName = transaction.receipient?.accountHolder
                } else {
                    accountNumber = transaction.sender?.accountNo
                    accountName = transaction.sender?.accountHolder
                }

                return TransactionsResponse.Transaction(
                    transactionId: transaction.transactionId,
                    amount: transaction.amount,
                    transactionDate: transaction.transactionDate?.toDate(),
                    description: transaction.description,
                    transactionType: transaction.transactionType,
                    accountNumber: accountNumber,
                    accountName: accountName
                )
            })
            return TransactionsResponse(
                status: status,
                transactions: transactions,
                error: .init(name: error?.name, message: error?.message, tokenExpiredDate: error?.expiredAt))
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> TransactionsResponse {
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error from TransactionsService", code: 0)
        }
        
        return response.transactionsResponse
    }
}

final class TransactionsService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<TransactionsResponse, Error>
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(token: String, completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
            switch result {
            case let .success(value):
                do {
                    completion(.success(try TransactionsServiceMapper.map(value.0, from: value.1)))
                } catch {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class TransactionsServiceTests: XCTestCase {

    func test_init_doesNotSendRequestToLoadTransactions() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_sendsRequestToLoadTransactions() {
        let url = URL(string: "https://any-url.com/transactions")!
        let (sut, client) = makeSUT(url)
        
        sut.load(token: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversErrorWithExpiredToken() {
        let url = URL(string: "https://any-url.com/transactions")!
        let (sut, client) = makeSUT(url)
        let (failedResponse, json) = makeTransactionsResponse(
            status: "failed",
            error: .init(
                name: "any name",
                message: "any message",
                tokenExpiredDate: "any date"
            )
        )
        let expectedResult = TransactionsService.Result.success(failedResponse)
        
        let exp = expectation(description: "Wait for loading transactions")
        sut.load(token: "any expired token") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedResponse), .success(expectedResponse)):
                XCTAssertEqual(receivedResponse, expectedResponse)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult)")
            }
            
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_successfullyLoadsTransactionsWithValidToken() {
        let url = URL(string: "https://any-url.com/transactions")!
        let (sut, client) = makeSUT(url)
        let transaction1 = makeTransaction(
            transactionId: "a transaction id",
            amount: 100,
            transactionDate: "a transaction date",
            description: "a description",
            transactionType: "received",
            accountNumber: "an account number",
            accountName: "an account name")
        
        let transaction2 = makeTransaction(
            transactionId: "another transaction id",
            amount: 10,
            transactionDate: "another transaction date",
            description: "another description",
            transactionType: "transfer",
            accountNumber: "another account number",
            accountName: "another account name")

        let (successResponse, json) = makeTransactionsResponse(
            status: "success",
            transactions: [transaction1, transaction2],
            error: nil
        )
        let expectedResult = TransactionsService.Result.success(successResponse)
        
        let exp = expectation(description: "Wait for loading transactions")
        sut.load(token: "any token") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedResponse), .success(expectedResponse)):
                XCTAssertEqual(receivedResponse, expectedResponse)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult)")
            }
            
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        wait(for: [exp], timeout: 1.0)
    }
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: TransactionsService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = TransactionsService(url: url, client: client)
        return (sut, client)
    }
    
    private func makeTransaction(
        transactionId: String,
        amount: Int,
        transactionDate: String,
        description: String,
        transactionType: String,
        accountNumber: String,
        accountName: String
    ) -> TransactionsResponse.Transaction {
        TransactionsResponse.Transaction(
            transactionId: transactionId,
            amount: amount,
            transactionDate: transactionDate.toDate(),
            description: description,
            transactionType: transactionType,
            accountNumber: accountNumber,
            accountName: accountName)
    }

    
    private func makeTransactionsResponse(
        status: String,
    transactions: [TransactionsResponse.Transaction]? = nil,
        error: TransactionsResponse.Error? = nil
    ) -> (response: TransactionsResponse, json: [String: Any]) {
        let transactionResponse = TransactionsResponse(
            status: status,
            transactions: transactions,
            error: .init(name: error?.name, message: error?.message, tokenExpiredDate: error?.tokenExpiredDate))
        
        let jsonTransactions: [[String: Any?]]? = transactions?.map({ transaction in
            var jsonTransaction: [String: Any?] = [
                "transactionId": transaction.transactionId,
                "amount": transaction.amount,
                "transactionDate": transaction.transactionDate,
                "description": transaction.description,
                "transactionType": transaction.transactionType
            ]
            let transactionType = transaction.transactionType == "received" ? "sender" : "receipient"
            jsonTransaction[transactionType] = [
                "accountNo": transaction.accountNumber,
                "accountHolder": transaction.accountName
            ]
            return jsonTransaction
        })
        
        let json: [String: Any] = [
            "status": status,
            "data" : jsonTransactions,
            "error": [
                "name": error?.name,
                "message": error?.message,
                "expiredAt": error?.tokenExpiredDate
            ]
        ].compactMapValues { $0 }
        
        return (transactionResponse, json)
    }
}
