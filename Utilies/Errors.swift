//
//  Errors.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/11/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation

/* An error enum
 Map http error code into the enum's
 */
enum QuakeErrors: Error {
    case unknown
    case success
    case notFound
    case timedOut
    case connectionError(value: Int)
    case serverUnavailable
    case noData
    case invalidRequest
    case invalidCredentials
    
    static func netError( _ errorCode: Int32 ) -> QuakeErrors {
        
        switch errorCode {
        case 200:
            return .success
        case 400:
            return .invalidRequest
        case 401:
            return .invalidCredentials
        case 404:
            return .notFound
        default:
            return .unknown
        }
    }
}
