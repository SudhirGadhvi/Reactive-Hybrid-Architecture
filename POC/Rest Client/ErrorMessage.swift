//
//  ErrorMessage.swift
//  POC
//
//  Created by SiD on 16/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorMessage: Mappable
{
    var message = ""
    
    required init?(map: Map){}
    
    init(message: String)
    {
       self.message = message
    }
    
    // Mappable
    func mapping(map: Map)
    {
        message <- map["message"]
    }
}

