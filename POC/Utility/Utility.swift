//
//  Utility.swift
//  POC
//
//  Created by SiD on 16/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit


let appDelegate = UIApplication.shared.delegate! as! AppDelegate

class Utility {
    
    // MARK:- Defining a singleton
    static private var sharedInstance = Utility()
    
    private init(){}
    
    static internal func getSharedInstance() -> Utility {
        return sharedInstance
    }
    
    // MARK:- Server domain
    let domain = "https://get.rosterbuster.com/wp-content/uploads/"
    
    // MARK:- API Client
    var restClient: RestClient = SGClient()
    
    // MARK:- Refresh control
    internal var refreshControl: UIRefreshControl = UIRefreshControl()
    
    /**
     *   method to check for network connectivity
     **/
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //MARK:- Alert With OK
    func showOkAlert(titleStr:String, msgStr:String) {
        let alertViewController = UIAlertController(title: titleStr, message: msgStr, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            alertViewController.dismiss(animated: true, completion: nil)
        }
        
        alertViewController.view.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        alertViewController.addAction(okAction)
        
        getTopMostViewController().present(alertViewController, animated: true, completion: nil)
    }
    
    func getTopMostViewController() -> UIViewController {
        var topViewController = appDelegate.window!.rootViewController! as UIViewController?
        while (topViewController!.presentedViewController != nil) {
            topViewController = topViewController!.presentedViewController!
        }
        return topViewController!
    }
    
    /**
     *   Convert date to String
     **/
    func formatDate(date: Date, formatStyle: String = "dd/MM/yyyy") -> String
    {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = formatStyle
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate
    }
    
    func convertStringDate(toDate: String, formatStyle: String = "dd/MM/yyyy") -> Date? {
        
        // Create date formatter
        let dateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = formatStyle
        
        
        return dateFormatter.date(from: toDate)
    }
}
