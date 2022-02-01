//
//  TransactionsServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

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
        amount: Double,
        transactionDate: String,
        description: String,
        transactionType: String,
        accountNumber: String,
        accountName: String
    ) -> TransactionsResponse.Transaction {
        TransactionsResponse.Transaction(
            transactionId: transactionId,
            amount: amount,
            transactionDate: transactionDate.shortDate(),
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
