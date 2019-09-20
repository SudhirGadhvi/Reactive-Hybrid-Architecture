//
//  EventsViewModel.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import UIKit

class EventsViewModel {
    
    // Model instance
    var events: Events?
    
    // Reactive properties
    var isErrorFree: Box<Content> = Box(Content())
    
    // Worker
    var worker: EventsWorker?
    
    init(_ events: Events?) {
        self.events = events
    }
    
    struct Response: Hashable {
        
        static func == (lhs: EventsViewModel.Response, rhs: EventsViewModel.Response) -> Bool {
            return lhs.sectionTitle.hashValue == rhs.sectionTitle.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(sectionTitle.hashValue)
        }
        var sectionTitle = ""
        var items: [Items]
    }
    
    struct Items {
        var title = ""
        var time = ""
        var dutyCode = ""
        var departure = ""
        var dutyId = ""
        
        var firstOfficer = ""
        var date = ""
        var timeDepart = ""
        var timeArrive = ""
        var destination = ""
        var captain = ""
        var flightAttendant = ""
    }
    
    internal func fetchEvents(completionHandler: @escaping([EventsViewModel.Response]?) -> Void) {
        
        guard Utility.getSharedInstance().isInternetAvailable() else {
            // Retriving data from Realm
            if let events = _Realm<Events>.retriveArray() {
                // creation of temp array to hold events
                var arrayOfEvents: [EventsViewModel.Response] = []
                for event in events {
                    let events = EventsViewModel.Response(sectionTitle: event.getDate() ?? "", items: [EventsViewModel.Items(title: event.getEventFullName() ?? "", time: event.getEventsTimeLine() ?? "", dutyCode: event.dutyCode, departure: event.departure, dutyId: event.dutyID, firstOfficer: event.firstOfficer, date: event.getDate() ?? "", timeDepart: event.timeDepart, timeArrive: event.timeArrive, destination: event.destination, captain: event.captain, flightAttendant: event.flightAttendant)])
                    
                    if arrayOfEvents.count == 0 {
                        arrayOfEvents = [events]
                    } else {
                        if let resIndex = arrayOfEvents.firstIndex(of: events) {
                            arrayOfEvents[resIndex].items.append(EventsViewModel.Items(title: event.getEventFullName() ?? "", time: event.getEventsTimeLine() ?? "", dutyCode: event.dutyCode, departure: event.departure, dutyId: event.dutyID, firstOfficer: event.firstOfficer, date: event.getDate() ?? "", timeDepart: event.timeDepart, timeArrive: event.timeArrive, destination: event.destination, captain: event.captain, flightAttendant: event.flightAttendant))
                        } else {
                            arrayOfEvents.append(events)
                        }
                    }
                }
                completionHandler(arrayOfEvents)
            }
            return
        }
        
        worker = EventsWorker(eventsWorkerProtocol: EventsApi())
        worker?.eventsWorkerProtocol?.fetchEvents(completionHandler: { (result) in
            switch(result) {
            case .success(let events):
                if events.count > 0 {
                    let response = self.getFinalResponse(events: events)
                    completionHandler(response)
                }
            case .failure(let error):
                switch (error) {
                case .failed(let message):
                    self.isErrorFree.value.message = message
                    self.isErrorFree.value.status = false
                    completionHandler(nil)
                }
            }
        })
    }
    
    internal func getFinalResponse(events: [Events]) -> [EventsViewModel.Response] {
        
        // creation of temp array to hold events
        var arrayOfEvents: [EventsViewModel.Response] = []
        
        //MARK:- NOTE:- To use Realm,there is no unique key which I can choose as a primary key in the API response I have added UUID in the array.
        let updatedEvents = events.map { (event) -> Events in
            event.udid = UUID().uuidString
            return event
        }
        
        // Storing data to Realm
        _Realm<Events>.storeArray(object: updatedEvents)
        
        for event in updatedEvents {
            let events = EventsViewModel.Response(sectionTitle: event.getDate() ?? "", items: [EventsViewModel.Items(title: event.getEventFullName() ?? "", time: event.getEventsTimeLine() ?? "", dutyCode: event.dutyCode, departure: event.departure, dutyId: event.dutyID, firstOfficer: event.firstOfficer, date: event.getDate() ?? "", timeDepart: event.timeDepart, timeArrive: event.timeArrive, destination: event.destination, captain: event.captain, flightAttendant: event.flightAttendant)])
            
            if arrayOfEvents.count == 0 {
                arrayOfEvents = [events]
            } else {
                if let resIndex = arrayOfEvents.firstIndex(of: events) {
                    arrayOfEvents[resIndex].items.append(EventsViewModel.Items(title: event.getEventFullName() ?? "", time: event.getEventsTimeLine() ?? "", dutyCode: event.dutyCode, departure: event.departure, dutyId: event.dutyID, firstOfficer: event.firstOfficer, date: event.getDate() ?? "", timeDepart: event.timeDepart, timeArrive: event.timeArrive, destination: event.destination, captain: event.captain, flightAttendant: event.flightAttendant))
                } else {
                    arrayOfEvents.append(events)
                }
            }
        }
        return arrayOfEvents
    }
}
