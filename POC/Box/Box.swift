//
//  Box.swift
//  POC
//
//  Created by SiD on 17/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T)-> Void
    var listener: Listener?
    
    var value: T
    {
        didSet
        {
            self.listener?(value)
        }
    }
    
    init(_ value: T)
    {
        self.value = value
    }
    
    func bind(listener: Listener?)
    {
        self.listener = listener
        self.listener?(value)
    }
}

