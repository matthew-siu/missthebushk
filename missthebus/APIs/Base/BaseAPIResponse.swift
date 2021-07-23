//
//  BaseAPIResponse.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation

struct SuccessResponse<R: APIResponse> {
    var header: ResponseHeaders?
    var body: R
}

struct CommonResult: APIResponse {
    let code: String?
    let sys_message: String?
    let message: String?
    
    var isError: Bool {
        return self.code != "0"
    }
}
