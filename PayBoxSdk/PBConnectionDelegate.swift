//
//  PBConnectionDelegate.swift
//  Pods
//
//  Created by Arman Mergenbayev on 23.11.2017.
//
//

import Foundation

protocol PBConnection {
    func onErrorResponse(response: [Int:String])
    func onSuccessConnection(command: PBHelper.OPERATION, response: String)
}

