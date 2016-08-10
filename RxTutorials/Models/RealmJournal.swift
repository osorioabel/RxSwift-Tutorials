//
//  RealmJournal.swift
//  Journal
//
//  Created by Abel Osorio on 8/10/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmJournal:Object {
    
    dynamic var id: String = NSUUID().UUIDString
    dynamic var date: NSDate = NSDate()
    dynamic var notes: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

}