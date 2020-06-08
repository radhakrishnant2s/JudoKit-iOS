//
//  JPPaymentMethodsInteractorMock.swift
//  JudoKit-iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

class JPPaymentMethodsInteractorMock: JPPaymentMethodsInteractor {
    func pollingPBBA(completion: JPCompletionBlock? = nil) {

    }
    
    func indexOfPBBAMethod() -> Int {
        return -1
    }

    func openPBBA(completion: JPCompletionBlock? = nil) {

    }

    var calledTransactionPayment = false
    var transactionCompleteError: Error?
    var cardSelected = false
    var startApplePay = false

    func completeTransaction(with response: JPResponse?, andError error: Error?) {
        transactionCompleteError = error
    }

    func storeError(_ error: Error) {

    }

    func setCardAsSelectedAt(_ index: UInt) {
        JPCardStorage.sharedInstance()?.setCardAsSelectedAt(index)
    }

    func getIDEALBankTypes() -> [Any] {
        return [0, 1]
    }

    func orderCards() {
        JPCardStorage.sharedInstance()?.orderCards()
    }

    func setLastUsedCardAt(_ index: UInt) {

    }

    func orederCards() {

    }

    func selectCard(at index: UInt) {
        cardSelected = true
    }

    func deleteCard(with index: UInt) {
        JPCardStorage.sharedInstance()?.deleteCard(with: index)
    }

    func setCardAsDefaultAt(_ index: Int) {

    }

    func getStoredCardDetails() -> [JPStoredCardDetails] {
        let cards = JPCardStorage.sharedInstance()?.fetchStoredCardDetails()
        return cards as! [JPStoredCardDetails]
    }


    func getAmount() -> JPAmount {
        let amount = JPAmount("1.0", currency: "EUR");
        return amount
    }

    func getPaymentMethods() -> [JPPaymentMethod] {
        return [JPPaymentMethod.card(), JPPaymentMethod.iDeal()]
    }

    func paymentTransaction(withToken token: String, andCompletion completion: JPCompletionBlock?) {
        calledTransactionPayment = true
    }

    func startApplePay(completion: JPCompletionBlock?) {
        let response = JPResponse()
        completion?(response,nil)
        startApplePay = true
    }

    func isApplePaySetUp() -> Bool {
        return false
    }

    func handle3DSecureTransaction(fromError error: Error, completion: JPCompletionBlock?) {

    }

    func saveMockCards() {
        let calendar = Calendar.current

        let todaysDate = Date()
        let dateInTwoMonths = calendar.date(byAdding: .month, value: 1, to: todaysDate)!
        let expiredDate = calendar.date(byAdding: .month, value: -1, to: todaysDate)!
        let notExpiredDate = calendar.date(byAdding: .month, value: 3, to: todaysDate)!

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = (kMonthYearDateFormat)

        let expiresSoonDateAsString = dateFormater.string(from: dateInTwoMonths)
        let expiredDateAsString = dateFormater.string(from: expiredDate)
        let notExpiredDateAsString = dateFormater.string(from: notExpiredDate)

        let validCard = JPStoredCardDetails(lastFour: "1111", expiryDate: notExpiredDateAsString, cardNetwork: .visa, cardToken: "token")!
        let expiresSoonCard = JPStoredCardDetails(lastFour: "1111", expiryDate: expiresSoonDateAsString, cardNetwork: .visa, cardToken: "token")!
        let expirdCard = JPStoredCardDetails(lastFour: "1111", expiryDate: expiredDateAsString, cardNetwork: .visa, cardToken: "token")!

        JPCardStorage.sharedInstance()?.add(validCard)
        JPCardStorage.sharedInstance()?.add(expiresSoonCard)
        JPCardStorage.sharedInstance()?.add(expirdCard)
    }
}
