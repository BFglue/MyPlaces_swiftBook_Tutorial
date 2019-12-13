//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Дмитрий Березин on 14/12/2019.
//  Copyright © 2019 Dmitry Berezin. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
}
