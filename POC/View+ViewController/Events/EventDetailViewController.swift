//
//  EventDetailViewController.swift
//  POC
//
//  Created by SiD on 20/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var followButton: UIButton?
    @IBOutlet var closeButton: UIButton?
    @IBOutlet var flighOfficeNameLabel: UILabel?
    @IBOutlet var dutyCodeLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var departureTimeLabel: UILabel?
    @IBOutlet var arrivalTimeLabel: UILabel?
    @IBOutlet var departureFromLabel: UILabel?
    @IBOutlet var destinationLabel: UILabel?
    @IBOutlet var captainNameLabel: UILabel?
    @IBOutlet var FlightAttendantLabel: UILabel?
    @IBOutlet var captainTitleLabel: UILabel?
    @IBOutlet var FlightAttendantTitleLabel: UILabel?
    
    // MARK:- Properties
    var eventsDetailViewModel = EventDetailViewModel(events: Events())
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK:- Action events
    @IBAction func buttonsActionEvents(_ sender: UIButton) {
        
        switch sender {
        case closeButton:
            self.dismiss(animated: true, completion: nil)
        case followButton:
            break
        default:
            break
        }
        
    }
    
}

// MARK:- UI setup
extension EventDetailViewController {
    
    fileprivate func setupUI() {
        self.flighOfficeNameLabel?.text = self.eventsDetailViewModel.events?.firstOfficer
        self.dutyCodeLabel?.text = self.eventsDetailViewModel.events?.dutyCode
        self.dateLabel?.text = self.eventsDetailViewModel.events?.getDate()
        self.departureTimeLabel?.text = self.eventsDetailViewModel.events?.timeDepart
        self.arrivalTimeLabel?.text = self.eventsDetailViewModel.events?.timeArrive
        self.departureFromLabel?.text = self.eventsDetailViewModel.events?.departure
        self.destinationLabel?.text = self.eventsDetailViewModel.events?.destination
        self.captainNameLabel?.text = self.eventsDetailViewModel.events?.captain
        self.FlightAttendantLabel?.text = self.eventsDetailViewModel.events?.flightAttendant
        if self.eventsDetailViewModel.events?.captain == "" {
         self.captainTitleLabel?.text = ""
        }
        
        if self.eventsDetailViewModel.events?.flightAttendant == "" {
         self.FlightAttendantTitleLabel?.text = ""
        }
    }
}
