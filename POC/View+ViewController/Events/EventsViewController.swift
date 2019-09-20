//
//  EventsViewController.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var eventsTableView: UITableView?
    
    // MARK:- Properties
    lazy fileprivate var eventsList: [EventsViewModel.Response] = []
    fileprivate var eventsViewModel = EventsViewModel(nil)
    var utility = Utility.getSharedInstance()
    var isPullToRefreshEnable = false
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setListener()
        // Setting up pull to refresh
        self.setUpPullToRefresh(table: self.eventsTableView)
    }
}

// MARK:- UI setup
extension EventsViewController {
    
    fileprivate func setupUI() {
        // Setup large navigation title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.shootRequestFetch()
    }
}

// MARK:- Listeners
extension EventsViewController {
    
    internal func setListener() {
        self.eventsViewModel.isErrorFree.bind { [unowned self] in
            if $0.status == false {
                self.utility.showOkAlert(titleStr: "", msgStr: $0.message ?? "")
                return
            }
        }
    }
}

// MARK:- Methods
extension EventsViewController {
    
    override func refresh(sender: AnyObject) {
        self.isPullToRefreshEnable = true
        self.shootRequestFetch()
    }
    
    fileprivate func shootRequestFetch() {
        if !self.isPullToRefreshEnable {
            self.showSpinner(onView: self.view)
        }
        self.eventsViewModel.fetchEvents { (events) in
            DispatchQueue.main.async {
                self.removeSpinner()
                self.utility.refreshControl.endRefreshing()
            }
            if let _events = events {
                if _events.count > 0 {
                    self.eventsList = _events
                    DispatchQueue.main.async {
                        self.eventsTableView?.reloadData()
                    }
                }
            }
        }
    }
}

// MARK:- TableView delegate methods
extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let eventDetailVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.EVENT_DETAIL) as? EventDetailViewController {
            eventDetailVC.eventsDetailViewModel.events?.firstOfficer = self.eventsList[indexPath.section].items[indexPath.row].firstOfficer
            eventDetailVC.eventsDetailViewModel.events?.date = self.eventsList[indexPath.section].items[indexPath.row].date
            eventDetailVC.eventsDetailViewModel.events?.dutyCode = self.eventsList[indexPath.section].items[indexPath.row].dutyCode
            eventDetailVC.eventsDetailViewModel.events?.timeDepart = self.eventsList[indexPath.section].items[indexPath.row].timeDepart
            eventDetailVC.eventsDetailViewModel.events?.timeArrive = self.eventsList[indexPath.section].items[indexPath.row].timeArrive
            eventDetailVC.eventsDetailViewModel.events?.departure = self.eventsList[indexPath.section].items[indexPath.row].departure
            eventDetailVC.eventsDetailViewModel.events?.destination = self.eventsList[indexPath.section].items[indexPath.row].destination
            eventDetailVC.eventsDetailViewModel.events?.captain = self.eventsList[indexPath.section].items[indexPath.row].captain
            eventDetailVC.eventsDetailViewModel.events?.flightAttendant = self.eventsList[indexPath.section].items[indexPath.row].flightAttendant
            
            DispatchQueue.main.async {
                self.navigationController?.present(eventDetailVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK:- TableView datasource methods
extension EventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.eventsList[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.EVENT, for: indexPath) as? EventsTableViewCell {

            cell.eventItemName?.text = self.eventsList[indexPath.section].items[indexPath.row].title
            cell.eventItemDesc?.text = ""
            cell.eventItemDetail?.text = ""
            cell.eventItemImage?.image = #imageLiteral(resourceName: "Plane")
            
            if self.eventsList[indexPath.section].items[indexPath.row].dutyCode == "LAYOVER" {
                cell.eventItemImage?.image = #imageLiteral(resourceName: "Brifcase")
                cell.eventItemName?.text = self.eventsList[indexPath.section].items[indexPath.row].dutyCode
                cell.eventItemDesc?.text = self.eventsList[indexPath.section].items[indexPath.row].departure
                cell.eventItemDetail?.text = ""
            }
            if self.eventsList[indexPath.section].items[indexPath.row].dutyCode == "Standby" {
                cell.eventItemImage?.image = #imageLiteral(resourceName: "Brifcase")
                cell.eventItemName?.text = self.eventsList[indexPath.section].items[indexPath.row].dutyCode
                cell.eventItemDesc?.text = "\(self.eventsList[indexPath.section].items[indexPath.row].dutyId) (ATL)"
                cell.eventItemDetail?.text = "Match Crew"
            }
            cell.eventItemTime?.text = self.eventsList[indexPath.section].items[indexPath.row].time
            return cell
        }
        return EventsTableViewCell()
    }
}
