//
//  EventsWorkerProtocol.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation

protocol EventsWorkerProtocol {
    func fetchEvents(completionHandler: @escaping EventsWorkerHandler)
}

typealias EventsWorkerHandler = (EventsWorkerResult<Events>) -> Void

enum EventsWorkerResult<U> {
    case success([U])
    case failure(EventsWorkerFailure)
}

enum EventsWorkerFailure {
    case failed(String)
}
