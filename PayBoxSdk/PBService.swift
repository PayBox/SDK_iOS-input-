//
//  PBService.swift
//  Pods
//
//  Created by Arman Mergenbayev on 23.11.2017.
//
//

import Foundation
import SystemConfiguration

class PBService {
    
    private let parser = ParseHelper.parser
    private var conDelegate : PBConnection!
    private var command : PBHelper.OPERATION;
    init(command: PBHelper.OPERATION, connection: PBConnection!, config: [String:String]!, secretKey: String){
        self.command = command
        self.conDelegate = connection
        var params:[(key: String, value: String)] = parser.sort(array: config)
        
        switch command {
        case .PAYMENT:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_ENTRY_URL, param: params)))
            create(url: Constants.PB_MAIN_URL+Constants.PB_ENTRY_URL, params: params)
            break
        case .REVOKE:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_REVOKE_URL, param: params)))
            create(url: Constants.PB_MAIN_URL+Constants.PB_REVOKE_URL, params: params)
            break
        case .CANCEL:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_CANCEL_URL, param: params)))
            create(url: Constants.PB_MAIN_URL+Constants.PB_CANCEL_URL, params: params)
            break
        case .CAPTURE:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_DO_CAPTURE_URL, param: params)))
            create(url: Constants.PB_MAIN_URL+Constants.PB_DO_CAPTURE_URL, params: params)
            break
        case .RECURRING:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_RECURRING_URL, param: params)))
            create(url: Constants.PB_MAIN_URL+Constants.PB_RECURRING_URL, params: params)
            break
        case .GETSTATUS:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_STATUS_URL, param: params)))
            create(url: Constants.PB_MAIN_URL+Constants.PB_STATUS_URL, params: params)
            break
        case .CARDLIST:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_LISTCARD_URL, param: params)))
            guard let item = item(from: params, item: Constants.PB_MERCHANT_ID) else {
                return
            }
            create(url: Constants.PB_CARD_MERCHANT(merchantId: Int(item)!)+Constants.PB_LISTCARD_URL, params: params)
            break
        case .CARDADD:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_ADDCARD_URL, param: params)))
            guard let item = item(from: params, item: Constants.PB_MERCHANT_ID) else {
                return
            }
            create(url: Constants.PB_CARD_MERCHANT(merchantId: Int(item)!)+Constants.PB_ADDCARD_URL, params: params)
            break
        case .CARDREMOVE:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_REMOVECARD_URL, param: params)))
            guard let item = item(from: params, item: Constants.PB_MERCHANT_ID) else {
                return
            }
            create(url: Constants.PB_CARD_MERCHANT(merchantId: Int(item)!)+Constants.PB_REMOVECARD_URL, params: params)
            break
        case .CARDINITPAY:
            params.append((key:Constants.PB_SIG, value:parser.sig(secretKey: secretKey, url: Constants.PB_CARDINITPAY, param: params)))
            guard let item = item(from: params, item: Constants.PB_MERCHANT_ID) else {
                return
            }
            create(url: Constants.PB_CARDPAY_MERCHANT(merchantId: Int(item)!)+Constants.PB_CARDINITPAY, params: params)
            break
        default:
            break
        }
    }
    private func create(url: String, params: [(key: String, value: String)]!){
        var paramts = [String:String]()
        params.forEach{
            paramts[$0.0] = $0.1
        }
        guard let parameters = try? JSONSerialization.data(withJSONObject: paramts, options: []) else {
            return
        }
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = parameters
        let session = URLSession.shared
        if isConnectedToNetwork(){
            DispatchQueue.global(qos: .background).async {
                session.dataTask(with: request) {data, response, err in
                    if let requestStatus = response as? HTTPURLResponse {
                        DispatchQueue.main.async {
                            if(requestStatus.statusCode == 200){
                                self.conDelegate.onSuccessConnection(command: self.command, response: String(data: data!, encoding: String.Encoding.utf8)!)
                            } else {
                                self.conDelegate.onErrorResponse(response: [0:Constants.FAILURE_ERROR])
                            }
                        }
                    }}.resume()
            }
        } else {
            conDelegate.onErrorResponse(response: Constants.INTERNET_ERROR)
        }
    }
    
    private func item(from: [(key: String, value: String)], item: String)->String?{
        for(key,value) in from {
            if key == item {
                return value
            }
        }
        return nil
    }
    
    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }
}

