//
//  EventsApi.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import ObjectMapper

struct EventsApi: EventsWorkerProtocol {
    
    let url = "\(Utility.getSharedInstance().domain)dummy-response.json"
    let utility = Utility.getSharedInstance()
    
    func fetchEvents(completionHandler: @escaping EventsWorkerHandler) {
        utility.restClient.request(url: url, httpMethod: RestMethod.get.rawValue, header: nil, body: nil, param: nil, isBackground: false) { (response) in
            
            if let result = response as? RestResult {
                if result.error != nil {                    completionHandler(EventsWorkerResult.failure((EventsWorkerFailure.failed(ApiErrorMessage.EVENTS_FETCH_FAILED))))
                } else {
                    dump(result.result)
                    if let res = result.result as? [[String : Any]] {
                        let eventsArray = Mapper<Events>().mapArray(JSONArray: res)
                        completionHandler(EventsWorkerResult.success(eventsArray))
                    }
                }
            }
        }
    }
}
