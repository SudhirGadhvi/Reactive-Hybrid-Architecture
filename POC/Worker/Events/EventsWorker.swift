//
//  EventsWorker.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation

class EventsWorker {
    
    var eventsWorkerProtocol: EventsWorkerProtocol?
    
    init(eventsWorkerProtocol: EventsWorkerProtocol?) {
        self.eventsWorkerProtocol = eventsWorkerProtocol
    }
}
