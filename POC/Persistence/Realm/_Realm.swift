//
//  _Realm.swift
//  POC
//
//  Created by SiD on 16/09/19.
//  Copyright © 2019 SiD. All rights reserved.
//

import Foundation
import RealmSwift

struct _Realm<T: Object>
{
    internal static func storeArray(object: [T]) {
        let realm = try! Realm()
        try! realm.write
        {
            realm.add(object, update: .modified)
        }  
    }
    
    internal static func retriveArray() -> [T]? {
        let realm = try! Realm()
        let objects = realm.objects(T.self as Object.Type).toArray(ofType : T.self) as [T]
        return objects.count > 0 ? objects : nil
    }
}

extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

