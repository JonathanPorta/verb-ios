//
//  Message.swift
//  Verb
//
//  Created by Jonathan Porta on 11/4/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var verb: String
    @NSManaged var acknowledgedAt: NSNumber
    @NSManaged var acknowledgedAtInWords: String
    @NSManaged var createdAt: NSNumber
    @NSManaged var createdAtInWords: NSNumber
    @NSManaged var activity: NSManagedObject
    @NSManaged var sender: NSManagedObject
    @NSManaged var recipient: NSManagedObject

}
