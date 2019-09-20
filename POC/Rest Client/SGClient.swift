//
//  SGClient.swift
//  POC
//
//  Created by SiD on 16/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import ObjectMapper

struct SGClient: RestClient {
    
    mutating func request(url: String, httpMethod: String,header: [String:String]?, body: [String:Any]?, param: [String:Any]?,isBackground: Bool, completion: @escaping (Any?)-> Void)
    {
        
        if Utility.getSharedInstance().isInternetAvailable() == true {
            request(url: url, method: httpMethod, parameters: param, headers: header) { (statusCode, data, response, result, error) in
                print(statusCode ?? "")
                switch(statusCode ?? 0)
                {
                case 200:
                    completion(RestResult(data: data, response: response, result: result, error: nil))
                    
                default:
                    completion(RestResult(data: data, response: response, result: result, error: error))
                }
            }
        } else {
            Utility.getSharedInstance().showOkAlert(titleStr: "Alert", msgStr: "No Internet Connection")
        }
    }
}

extension SGClient {
    
    func request(url: String, method: String, parameters: [String: Any]?, headers: [String: String]?, completion:@escaping ((_ statusCode: Int?, _ data: Data?, _ response: HTTPURLResponse?, _ result: Any?, _ error: RestError?) -> Void)) {
        guard let resURL = URL(string: url) else {
            completion(400, nil, nil, nil, RestError.requestFailed)
            return
        }
        var request = URLRequest(url: resURL, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        if let resHeaders = headers {
            for header in resHeaders {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        if let resParam = parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: resParam, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
            }
            catch {
                print(error)
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let resResopnse = response as? HTTPURLResponse {
                if resResopnse.statusCode >= 400 {
                    if let resData = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: resData, options: JSONSerialization.ReadingOptions.allowFragments)
                            completion(resResopnse.statusCode, data, resResopnse, json, RestError.requestFailed)
                        }
                        catch {
                            completion(resResopnse.statusCode, data, resResopnse, nil, RestError.requestFailed)
                            print(error)
                        }
                    }
                    else {
                        completion(resResopnse.statusCode, data, resResopnse, nil, RestError.requestFailed)
                    }
                }
                else {
                    if let resData = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: resData, options: JSONSerialization.ReadingOptions.allowFragments)
                            completion(resResopnse.statusCode, data, resResopnse, json, nil)
                        }
                        catch {
                            completion(resResopnse.statusCode, data, resResopnse, nil, nil)
                            print(error)
                        }
                    }
                    else {
                        completion(resResopnse.statusCode, data, resResopnse, nil, nil)
                    }
                }
            }
            else {
                if let resData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: resData, options: JSONSerialization.ReadingOptions.allowFragments)
                        completion(200, data, nil, json, RestError.requestFailed)
                    }
                    catch {
                        completion(400, data, nil, nil, RestError.requestFailed)
                        print(error)
                    }
                }
                else {
                    completion(400, data, nil, nil, RestError.requestFailed)
                }
            }
        }
        dataTask.resume()
    }
}
