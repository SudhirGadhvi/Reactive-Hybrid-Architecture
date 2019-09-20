//
//  RestHeader.swift
//  POC
//
//  Created by SiD on 16/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation

struct RestHeader: Header
{
    private var restHeader: [String: String]?
    
    var header: [String : String]?
    {
        get
        {
            return restHeader
        }
        
        set
        {
            self.restHeader = newValue
        }
        
    }
    
    internal init(header: [String: String])
    {
        self.restHeader = header
    }
    
    internal mutating func add(header : [String: String])-> [String:String]?
    {
        var tempHeader = self.restHeader
        for (key, value) in header
        {
            tempHeader!.updateValue(value, forKey: key)
        }
        
        return tempHeader
    }
    
    internal mutating func remove(key : String)-> [String:String]?
    {
        var tempHeader = self.restHeader
        tempHeader!.removeValue(forKey: key)
        
        return tempHeader
    }
    
}
