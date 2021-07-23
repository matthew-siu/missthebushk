//
//  NetworkAsyncQueue.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Connection Opertaion
class ConcurrentOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    
    fileprivate var _executing: Bool = false
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if (_executing != newValue) {
                self.willChangeValue(forKey: "isExecuting")
                _executing = newValue
                self.didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    fileprivate var _finished: Bool = false
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if (_finished != newValue) {
                self.willChangeValue(forKey: "isFinished")
                _finished = newValue
                self.didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    func completeOperation() {
        isExecuting = false
        isFinished  = true
    }
    
    override func start() {
        if (isCancelled) {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        main()
    }
}

typealias NetworkOperationCompletion = (DataResponse<String>) -> Void
final class APIOperation<T: Repository>: ConcurrentOperation {
    // define properties to hold everything that you'll supply when you instantiate
    // this object and will be used when the request finally starts
    //
    // in this example, I'll keep track of (a) URL; and (b) closure to call when request is done
    
    let repo: T
    let networkOperationCompletionHandler: NetworkOperationCompletion
    
    // we'll also keep track of the resulting request operation in case we need to cancel it later
    
    var alamofireRequest: Alamofire.Request?
    
    init(repo: T, networkOperationCompletionHandler: @escaping NetworkOperationCompletion) {
        self.repo = repo
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
    }
    
    // when the operation actually starts, this is the method that will be called
    
    override func main() {
        self.alamofireRequest = API
            .manager
            .request(
                self.repo.urlPath,
                method: self.repo.method.alamofireMethod ?? .get,
                parameters: self.repo.body,
                encoding: self.repo.encoding,
                headers: self.repo.headers
            )
            .responseString(completionHandler: { (res) in
                self.networkOperationCompletionHandler(res)
                self.completeOperation()
            })
        
        self.alamofireRequest?.resume()
    }
    
    override func cancel() {
        self.alamofireRequest?.cancel()
        super.cancel()
    }
}
