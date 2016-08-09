//
//  User.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable {
    var username: String!
    var firstName: String!
    var lastName: String!
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        username <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}
