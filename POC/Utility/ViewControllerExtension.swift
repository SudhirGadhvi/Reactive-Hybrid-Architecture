//
//  ViewControllerExtension.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import UIKit

// MARK:- Extension for pull-to-refresh
extension UIViewController {
    
    internal func setUpPullToRefresh(table: UITableView?)
    {
        Utility.getSharedInstance().refreshControl.addTarget(self, action: #selector(self.refresh(sender:)) , for: UIControl.Event.valueChanged)
        table?.addSubview(Utility.getSharedInstance().refreshControl) // not required when using UITableViewController
    }
    
    // override it in view-controllers which are refreshable
    @objc internal func refresh(sender: AnyObject){}
    
    internal func showUpcomingDialog(message: String)
    {
       Utility.getSharedInstance().showOkAlert(titleStr: "", msgStr: message)
        
    }
}

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
