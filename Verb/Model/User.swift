//
//  User.swift
//  Verb
//
//  Created by Jonathan Porta on 11/4/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var email: String

}
