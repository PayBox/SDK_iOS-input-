

import Foundation
protocol ApiProtocol {
    
    func onPaymentInited(payment: Payment?, error: Error?)
    func onPaymentRevoked(payment: Payment?, error: Error?)
    func onPaymentCanceled(payment: Payment?, error: Error?)
    func onCapture(capture: Capture?, error: Error?)
    func onPaymentStatus(status: Status?, error: Error?)
    func onPaymentRecurring(recurringPayment: RecurringPayment?, error: Error?)
    func onNonAcceptanceDirected(payment: Payment?, error: Error?)
    func onCardAdding(payment: Payment?, error: Error?)
    func onCardListing(cards: Array<Card>?, error: Error?)
    func onCardRemoved(card: Card?, error: Error?)
    func onCardPayInited(payment: Payment?, error: Error?)
    func onApplePayInited(paymentId: String?, error: Error?)
    func onApplePayPaid(payment: Payment?, error: Error?)
}
