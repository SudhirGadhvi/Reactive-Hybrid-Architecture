//
//  RestClient.swift
//  POC
//
//  Created by SiD on 16/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation

protocol RestClient
{
    mutating func request(url: String,httpMethod: String ,header: [String:String]?, body: [String:Any]?, param: [String:Any]?,isBackground: Bool, completion: @escaping (Any?)-> Void)
}

protocol Header
{
    var header: [String : String]? {get set}
}

protocol Result
{
    associatedtype T
    associatedtype U
    associatedtype V
    associatedtype W
    
    var data: T? {get}
    var response: U? {get}
    var result: V? {get}
    var error: W? {get}
}

enum Status: Int
{
    case success = 200
    case noData  = 404
}

enum ResponseError: Error
{
    case zeroResult(String)
}

enum RestMethod: String
{
    case post   = "POST"
    case get    = "GET"
    case delete = "DELETE"
    case put    = "PUT"
}
