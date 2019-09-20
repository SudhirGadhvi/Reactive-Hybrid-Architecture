//
//  Events.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Events: Object, Mappable {
    
    @objc dynamic var udid = ""
    @objc dynamic var flightnr = ""
    @objc dynamic var date = ""
    @objc dynamic var aircraftType = ""
    @objc dynamic var tail = ""
    @objc dynamic var departure = ""
    @objc dynamic var destination = ""
    @objc dynamic var timeDepart = ""
    @objc dynamic var timeArrive = ""
    @objc dynamic var dutyID = ""
    @objc dynamic var dutyCode = ""
    @objc dynamic var captain = ""
    @objc dynamic var firstOfficer = ""
    @objc dynamic var flightAttendant = ""
    
    override static func primaryKey() -> String? {
        return "udid"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.flightnr           <- map["Flightnr"]
        self.date               <- map["Date"]
        self.aircraftType       <- map["Aircraft Type"]
        self.tail               <- map["Tail"]
        self.departure          <- map["Departure"]
        self.destination        <- map["Destination"]
        self.timeDepart         <- map["Time_Depart"]
        self.timeArrive         <- map["Time_Arrive"]
        self.dutyID             <- map["DutyID"]
        self.dutyCode           <- map["DutyCode"]
        self.captain            <- map["Captain"]
        self.firstOfficer       <- map["First Officer"]
        self.flightAttendant    <- map["Flight Attendant"]
    }
}

extension Events {
    func getDate() -> String? {
        if let date = Utility.getSharedInstance().convertStringDate(toDate: self.date, formatStyle: "dd/MM/yyyy") {
            return Utility.getSharedInstance().formatDate(date: date, formatStyle: "d MMM, yyyy")
        }
        return ""
    }
    
    func getEventFullName() -> String? {
        return "\(self.departure) - \(self.destination)".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func getEventsTimeLine() -> String? {
        let timeLine = "\(self.timeDepart) - \(self.timeArrive)"
        if timeLine != " - " {
            if timeLine.contains("00:00:00") {
                return timeLine.replacingOccurrences(of: "00:00:00 - ", with: "")
            } else {
                return timeLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
        } else {
            return ""
        }
    }
}
