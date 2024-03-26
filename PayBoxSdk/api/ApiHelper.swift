
import Foundation
import CommonCrypto

open class ApiHelper: SignHelper {
    private var listener: ApiProtocol? = nil
    init(secretKey: String, listener: ApiProtocol) {
        super.init(secretKey: secretKey)
        self.listener = listener
    }
    
    func initConnection(url: String, params: [String:String], paymentType: String? = nil) {
        request(requestData: {
            RequestData(params: self.signedParams(url: url, array: params), method: RequestMethod.POST, url: url, paymentType: paymentType ?? "")
        })
    }
}

extension ApiHelper {
    func request(requestData: @escaping () -> RequestData) {
        DispatchQueue.global(qos: .background).async {
            self.connection(requestData: requestData(), connection: {
                responseData in
                DispatchQueue.main.async {
                    self.resolveResponse(result: responseData, paymentType: requestData().paymentType)
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
        if requestData.url.contains(Urls.getCustomerUrl() + Urls.PAY_ROUTE) {
            request.addValue(Urls.getCustomerDomain(), forHTTPHeaderField: "Host")
            request.addValue(Urls.getCustomerUrl(), forHTTPHeaderField: "Origin")
        }
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
                } else {
                    connection(ResponseData(
                        code: statusCode,
                        response: String(data: data!, encoding: .utf8)!,
                        url: requestData.url,
                        error: true))
                }
            }
            }.resume()
    }
    
    private func resolveResponse(result: ResponseData?, paymentType: String? = nil) {
        if let result = result {
            if !result.error {
                if result.response.contains(Params.RESPONSE) {
                    if isSuccess(xml: result.response) {
                        apiHandler(url: result.url, xml: result.response, error: nil, paymentType: paymentType)
                    } else {
                        handleError(data: result, paymentType: paymentType)
                    }
                } else if result.response.contains(Params.DATA) {
                    if result.response.isApplePaymentSuccess() {
                        apiHandler(url: result.url, xml: result.response, error: nil, paymentType: paymentType)
                    } else {
                        apiHandler(url: result.url, xml: nil, error: result.response.getApplePaymentError(), paymentType: paymentType)
                    }
                } else {
                    apiHandler(url: result.url, xml: result.response, error: Error(
                        errorCode: 0,
                        description: Params.FORMAT_ERROR), paymentType: paymentType)
                }
            } else {
                if result.response.contains(Params.RESPONSE) {
                    handleError(data: result, paymentType: paymentType)
                } else if result.response.contains(Params.DATA) {
                    apiHandler(url: result.url, xml: nil, error: result.response.getApplePaymentError(), paymentType: paymentType)
                } else {
                    apiHandler(url: result.url, xml: nil, error: Error(
                        errorCode: result.code,
                        description: result.response), paymentType: paymentType)
                }
            }
        }
    }
    
    private func handleError(data: ResponseData, paymentType: String? = nil) {
        let code = data.response.getIntValue(key: Params.ERROR_CODE)
        let description = data.response.getStringValue(key: Params.ERROR_DESCRIPTION)
        apiHandler(url: data.url, xml: nil, error: Error(
            errorCode: code ?? 520,
            description: description ?? Params.UNKNOWN_ERROR), paymentType: paymentType)
    }
    
    private func apiHandler(url: String, xml: String?, error: Error?, paymentType: String? = nil) {
        if url.contains(Urls.initPaymentUrl()) {
            if paymentType == Params.APPLE_PAY {
                let paymentId = xml?.getPaymentId()
                
                if paymentId != nil {
                    self.listener?.onApplePayInited(paymentId: paymentId, error: error)
                } else {
                    let initError = Error(
                        errorCode: 0,
                        description: Params.PAYMENT_ERROR)
                    self.listener?.onApplePayInited(paymentId: nil, error: initError)
                }
            } else {
                self.listener?.onPaymentInited(payment: xml?.getPayment(), error: error)
            }
        } else if url.contains(Urls.revokeUrl()) {
            self.listener?.onPaymentRevoked(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.cancelUrl()) {
            self.listener?.onPaymentCanceled(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.revokeUrl()) {
            self.listener?.onPaymentRevoked(payment: xml?.getPayment(), error: error)
        } else if url.contains(Urls.clearingUrl()) {
            self.listener?.onCapture(capture: xml?.getCapture(), error: error)
        } else if url.contains(Urls.statusUrl()) {
            self.listener?.onPaymentStatus(status: xml?.getStatus(), error: error)
        } else if url.contains(Urls.recurringUrl()) {
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
        } else if url.contains(Urls.getCustomerUrl() + Urls.PAY_ROUTE) {
            self.listener?.onApplePayPaid(payment: xml?.getApplePayment(), error: error)
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
    
    func getPaymentId() -> String? {
        let url = self.getPayment().redirectUrl
        var components = [""]
        
        if url?.contains("\(Params.PAYMENT_ID)=") == true {
            components = url!.components(separatedBy: "\(Params.PAYMENT_ID)=")
        }
        
        if url?.contains("\(Params.CUSTOMER)=") == true {
            components = url!.components(separatedBy: "\(Params.CUSTOMER)=")
        }
        
        if components.count > 1 {
            return components[1].components(separatedBy: "&")[0]
        }
        
        return nil
    }
    
    func isApplePaymentSuccess() -> Bool {
        guard let paymentData = try? JSONSerialization.jsonObject(with: Data(self.utf8), options: []) as? [String : Any] else {
            return false
        }
        
        let data = paymentData?[Params.TAG_DATA] as? [String: Any]
        let status = data?[Params.TAG_STATUS] as? String
        
        return status == Params.STATUS_OK
    }
    
    func getApplePayment() -> Payment {
        guard let paymentData = try? JSONSerialization.jsonObject(with: Data(self.utf8), options: []) as? [String : Any] else {
            return Payment(
            status: "", paymentId: 0, merchantId: "", orderId: "", redirectUrl: ""
            )
        }
        
        let data = paymentData?[Params.TAG_DATA] as? [String: Any]
        let status = data?[Params.TAG_STATUS] as? String ?? ""
        let backUrl = data?[Params.TAG_BACK_URL] as? [String: Any]
        let url = backUrl?[Params.TAG_URL] as? String ?? ""
        let params = backUrl?[Params.TAG_PARAMS] as? [String: Any]
        let orderId = params?[Params.ORDER_ID] as? String ?? ""
        let paymentId = params?[Params.PAYMENT_ID] as? Int ?? 0
        
        return Payment(
            status: status,
            paymentId: paymentId,
            merchantId: "",
            orderId: orderId,
            redirectUrl: url
        )
    }
    
    func getApplePaymentError() -> Error {
        guard let paymentData = try? JSONSerialization.jsonObject(with: Data(self.utf8), options: []) as? [String : Any] else {
            return Error(errorCode: 0, description: Params.FORMAT_ERROR)
        }
        
        let data = paymentData?[Params.TAG_DATA] as? [String: Any]
        let code = data?[Params.TAG_CODE] as? Int ?? 0
        let message = data?[Params.TAG_MESSAGE] as? String ?? Params.PAYMENT_ERROR
        
        let unescapedMessageData = Data(
            message
                .replacingOccurrences(of: #"\U"#, with: #"\u"#)
                .applyingTransform(.init("Hex-Any"), reverse: false)!
                .utf8
        )
        let unescapedMessage = NSString(data: unescapedMessageData, encoding: NSUTF8StringEncoding)!
        
        return Error(errorCode: code, description: unescapedMessage as String)
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
