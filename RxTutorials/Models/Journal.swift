//
//  Journal.swift
//  Journal
//
//  Created by Abel Osorio on 8/9/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

func == (lhs: Journal, rhs: Journal) -> Bool {
    return lhs.id == rhs.id
}

struct Journal {
    
    var id: String
    var date: NSDate
    var notes: String
}

extension Journal : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return id }
}

extension Journal : Equatable { }

extension Journal : Persistable {

    static var entityName: String {
        return "Journal"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: NSManagedObject) {
        id = entity.valueForKey("id") as! String
        date = entity.valueForKey("date") as! NSDate
        notes = entity.valueForKey("notes") as! String
    }
    
    func update(entity: NSManagedObject) {
        entity.setValue(id, forKey: "id")
        entity.setValue(date, forKey: "date")
        entity.setValue(notes, forKey: "notes")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }

}