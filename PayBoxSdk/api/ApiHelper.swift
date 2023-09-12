
import Foundation
import CommonCrypto

open class ApiHelper: SignHelper {
    private var listener: ApiProtocol? = nil
    init(secretKey: String, listener: ApiProtocol) {
        super.init(secretKey: secretKey)
        self.listener = listener
    }
    func initConnection(url: String, params: [String:String]) {
        request(requestData: {
            RequestData(params: self.signedParams(url: url, array: params), method: RequestMethod.POST, url: url)
        })
    }
}

extension ApiHelper {
    func request(requestData: @escaping () -> RequestData) {
        DispatchQueue.global(qos: .background).async {
            self.connection(requestData: requestData(), connection: {
                responseData in
                DispatchQueue.main.async {
                    self.resolveResponse(result: responseData)
                }
            })
            
        }
    }
    
    private func connection(requestData: RequestData, connection: @escaping (ResponseData) -> Void) {
        let urlCon = URL(string: requestData.url)
        guard let clUrl = urlCon else {
            return
        }
        let signedParams = requestData.params
        var paramts = [String:String]()
        signedParams.forEach{
            paramts[$0.0] = $0.1
        }
        guard let parameters = try? JSONSerialization.data(withJSONObject: paramts, options: []) else {
            return
        }
        var request = URLRequest(url: clUrl)
        request.httpMethod = requestData.method.rawValue
        request.timeoutInterval = 25000
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = parameters
        URLSession.shared.dataTask(with: request) {
            data, response, err in
            if let error = err {
                connection(ResponseData(
                    code: 522,
                    response: error.localizedDescription, url: requestData.url, error: true))
                return
            }
            if let requestStatus = response as? HTTPURLResponse {
                let statusCode = requestStatus.statusCode
                if(statusCode == 200){
                    guard let strResponse = String(data: data!, encoding: String.Encoding.utf8) else {
                        return
                    }
                    connection(ResponseData(
                        code: statusCode,
                        response: strResponse,
                        url: requestData.url,
                        error: statusCode != 200))
                }
            }
            }.resume()
    }
    
    private func resolveResponse(result: ResponseData?) {
        if let result = result {
            if !result.error {
                if result.response.contains(Params.RESPONSE) {
                    if isSuccess(xml: result.response) {
                        apiHandler(url: result.url, xml: result.response, error: nil)
                    } else {
                        handleError(data: result)
                    }
                } else {
                    apiHandler(url: result.url, xml: nil, error: Error(
                        errorCode: 0,
                        description: Params.FORMAT_ERROR))
                }
            } else {
                if result.response.contains(Params.RESPONSE) {
                    handleError(data: result)
                } else {
                    apiHandler(url: result.url, xml: nil, error: Error(
                        errorCode: result.code,
                        description: result.response))
                }
            }
        }
    }
    
    private func handleError(data: ResponseData) {
        let code = data.response.getIntValue(key: Params.ERROR_CODE)
        let description = data.response.getStringValue(key: Params.ERROR_DESCRIPTION)
        apiHandler(url: data.url, xml: nil, error: Error(
            errorCode: code ?? 520,
            description: description ?? Params.UNKNOWN_ERROR))
    }
    
    private func apiHandler(url: String, xml: String?, error: Error?) {
        if url.contains(Urls.INIT_PAYMENT_URL) {
            self.listener?.onPaymentInited(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.REVOKE_URL) {
            self.listener?.onPaymentRevoked(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.CANCEL_URL) {
            self.listener?.onPaymentCanceled(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.REVOKE_URL) {
            self.listener?.onPaymentRevoked(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.CLEARING_URL) {
            self.listener?.onCapture(capture: xml?.getCapture(), error: error)
        } else if url.contains(Urls.STATUS_URL) {
            self.listener?.onPaymentStatus(status: xml?.getStatus(), error: error)
        } else if url.contains(Urls.RECURRING_URL) {
            self.listener?.onPaymentRecurring(recurringPayment: xml?.getRecurringPayment(), error: error)
        } else if url.contains(Urls.CARDSTORAGE + Urls.ADDCARD_URL) {
            self.listener?.onCardAdding(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.CARDSTORAGE + Urls.LISTCARD_URL) {
            self.listener?.onCardListing(cards: xml?.getCards(), error: error)
        } else if url.contains(Urls.CARDSTORAGE + Urls.REMOVECARD_URL) {
            self.listener?.onCardRemoved(card: xml?.getCard(), error: error)
        } else if url.contains(Urls.CARD + Urls.CARDINITPAY) {
            self.listener?.onCardPayInited(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.CARD + Urls.DIRECT) {
            self.listener?.onNonAcceptanceDirected(payment: xml?.getPayment(), error: error)
        }
    }
    
    private func isSuccess(xml: String) -> Bool {
        return !(xml.getStringValue(key: Params.STATUS) ?? "error").elementsEqual("error")
    }
}
extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    func getPayment()-> Payment {
        return Payment(
            status: self.getStringValue(key: Params.STATUS),
            paymentId: self.getIntValue(key: Params.PAYMENT_ID),
            merchantId: self.getStringValue(key: Params.MERCHANT_ID),
            orderId: self.getStringValue(key: Params.ORDER_ID),
            redirectUrl: self.getStringValue(key: Params.REDIRECT_URL))
    }
    
    func getRecurringPayment()-> RecurringPayment {
        return RecurringPayment(
            status: self.getStringValue(key: Params.STATUS),
            paymentId: self.getIntValue(key: Params.PAYMENT_ID),
            currency: self.getStringValue(key: Params.CURRENCY),
            amount: self.getFloatValue(key: Params.AMOUNT),
            recurringProfile: self.getStringValue(key: Params.RECURRING_PROFILE),
            recurringExpireDate: self.getStringValue(key: Params.RECURRING_PROFILE_EXPIRY))
    }
    
    func getCard() -> Card {
        return Card(
            status: self.getStringValue(key: Params.STATUS),
            merchantId: self.getStringValue(key: Params.MERCHANT_ID),
            cardId: self.getStringValue(key: Params.CARD_ID),
            cardToken: self.getStringValue(key: Params.CARD_TOKEN),
            recurringProfile: self.getStringValue(key: Params.RECURRING_PROFILE_ID),
            cardhash: self.getStringValue(key: Params.CARD_HASH),
            date: self.getStringValue(key: Params.CARD_CREATED_AT))
    }
    
    func getCards() -> [Card] {
        var cards = [Card]()
        let arraySt = self.components(separatedBy: "<card>")
        if arraySt.count > 1 {
            for index in 1...(arraySt.count-1) {
                var arrayF: String {
                    return arraySt[(index)].components(separatedBy: "</card>")[0]
                }
                cards.append(arrayF.getCard())
            }
        }
        return cards
    }
    
    func getStatus()-> Status {
        return Status(
            status: self.getStringValue(key: Params.STATUS),
            paymentId: self.getIntValue(key: Params.PAYMENT_ID),
            transactionStatus: self.getStringValue(key: Params.TRANSACTION_STATUS),
            canReject: self.getStringValue(key: Params.CAN_REJECT),
            isCaptured: self.getStringValue(key: Params.CAPTURED),
            cardPan: self.getStringValue(key: Params.CARD_PAN),
            createDate: self.getStringValue(key: Params.CREATED_AT))
    }
    
    func getCapture() -> Capture {
        return Capture(
            status: self.getStringValue(key: Params.STATUS),
            amount: self.getFloatValue(key: Params.AMOUNT),
            clearingAmount: self.getFloatValue(key: Params.CLEARING_AMOUNT))
    }
    
    func getStringValue(key: String)-> String? {
        var value: String?
        let argSt =  self.components(separatedBy: "<"+key+">")
        if argSt.count > 1 {
            value = argSt[1].components(separatedBy: "</"+key+">")[0]
        }
        return value
    }
    
    func getFloatValue(key: String)-> Float? {
        var value: Float?
        let argSt =  self.components(separatedBy: "<"+key+">")
        if argSt.count > 1 {
            value = Float(argSt[1].components(separatedBy: "</"+key+">")[0])
        }
        return value
    }
    
    func getIntValue(key: String)-> Int? {
        var value: Int?
        let argSt =  self.components(separatedBy: "<"+key+">")
        if argSt.count > 1 {
            value = Int(argSt[1].components(separatedBy: "</"+key+">")[0])
        }
        return value
    }
}
