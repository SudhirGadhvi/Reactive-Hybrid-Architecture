//
//  RestResult.swift
//  POC
//
//  Created by SiD on 16/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import ObjectMapper

struct RestResult: Result
{
    private var requestData: Data?
    private var requestResponse: HTTPURLResponse?
    private var requestResult: Any?
    private var requestError: RestError?
    
    internal var data: Data?
    {
        return self.requestData
    }
    
    internal var response: HTTPURLResponse?
    {
        return self.requestResponse
    }
    
    internal var result: Any?
    {
        return self.requestResult
    }
    
    internal var error: RestError?
    {
        return self.requestError
    }
    
    internal init(data requestData: Data?, response requestResponse: HTTPURLResponse?, result requestResult: Any?, error requestError: RestError?)
    {
        self.requestData = requestData
        self.requestResponse = requestResponse
        self.requestResult = requestResult
        self.requestError = requestError
    }
}

struct Response: Mappable
{
    var code = 0
    var message = ""
    var error = ""
    
    init?(map: Map){}
    
    // Mappable
    mutating func mapping(map: Map)
    {
        code <- map["ResponseCode"]
        message <- map["ResponseMessage"]
        error <- map["Error"]
    }
}

enum RestError: Error
{
    case requestFailed
}
