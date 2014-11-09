//
//  Activity.swift
//  Verb
//
//  Created by Jonathan Porta on 11/4/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import CoreData

class Activity: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var activityMessage: String
    @NSManaged var type: String
    @NSManaged var message: Message

}
