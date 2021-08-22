//
//  NetworkOperation.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation

import Alamofire
import PromiseKit

extension API {
    @discardableResult
    public static func send<R: Repository>(repository: R, usingQueue queue: OperationQueue? = nil) -> Promise<(R.ResponseType?, ResponseHeaders?)> {
        return Promise { seal in
            send(repository: repository, usingQueue: queue, completion: { (result) in
                switch result {
                case .success(let response, let headers):
                    seal.fulfill((response, headers))
                case .failure(let error):
                    print("API error: \(error.localizedDescription)")
                    seal.reject(error)
                }
            })
        }
    }
    
    public static func send<R: Repository>(repository: R, usingQueue queue: OperationQueue? = nil, completion: ((APIResult<R.ResponseType>) -> Void)?) {
        let apiOperation = APIOperation(repo: repository) { (requestResult) in

//            print("repository api: \(R.ResponseType.self) \(repository.urlPath)")
//            print("repository: \(requestResult.description)")
            
            // 0. SSL Error
            if self.isSSLError(error: requestResult.error) {
                completion?(APIResult.failure(APIError.sslError))
            }
                
                // 1. If error is defined at the very first stage
                // ** Note that result.error is equal to error directly!
            else if let error = requestResult.error {
                
                switch error._code {
                case NSURLErrorTimedOut:
                    completion?(APIResult.failure(.timeout))
                case NSURLErrorCancelled:
                    completion?(APIResult.failure(.cancelled))
                default:
                    // if there is status code found in response but error occurred
                    if let statusCode = requestResult.response?.statusCode {
                        let httpError = APIError.http(statusCode)
                        completion?(APIResult.failure(httpError))
                    }
                        
                        // Cancel error
                    else if requestResult.error?.isCancelled ?? false {
                        completion?(APIResult.failure(.cancelled))
                    }
                        
                        // if no, connection error / eg. -1001
                    else {
                        completion?(APIResult.failure(.connection))
                    }
                }
            }
                
                // 2. Normal case
            else if let statusCode = requestResult.response?.statusCode {
                switch statusCode {
                // Success case
                case 200...299:
//                    print("resp: statusCode \(statusCode)")
                    if let jsonData = requestResult.data, let decoded = try? API.decoder.decode(R.ResponseType.self, from: jsonData) {
//                        print("resp: decoded")
                        completion?(.success(decoded, requestResult.response?.allHeaderFields))
                    }
                    else if repository.allowNil {
//                        print("resp: allowNil")
                        completion?(.success(nil, requestResult.response?.allHeaderFields))
                    }
                    else {
//                        print("resp: unexpectedResponse")
                        completion?(APIResult.failure(.unexpectedResponse))
                    }
                // Unexpected case
                default:
                    completion?(APIResult.failure(.http(statusCode)))
                }
            }
                
                // 3. Exceptional
            else {
                completion?(APIResult.failure(.unexpectedResponse))
            }

        }
        
        // Put operation into queun
        if let aQueue = queue {
            aQueue.addOperation(apiOperation)
        }
        else {
            API.globalOperationQueue.addOperation(apiOperation)
        }
    }
}

// MARK: - SSL Pinning
extension API {
    fileprivate static func isSSLError(error: Error?) -> Bool {
        guard let nsError = error as NSError?
            else { return false }
        
        switch nsError.code {
        case NSURLErrorSecureConnectionFailed,
             NSURLErrorServerCertificateHasBadDate,
             NSURLErrorServerCertificateUntrusted,
             NSURLErrorServerCertificateHasUnknownRoot,
             NSURLErrorServerCertificateNotYetValid,
             NSURLErrorClientCertificateRejected,
             NSURLErrorClientCertificateRequired,
             NSURLErrorCannotLoadFromNetwork:
            return true
        default:
            return false
        }
    }
}
