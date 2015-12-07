//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by miha perne on 03/12/15.
//  Copyright © 2015 miha perne. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var name: String?
    @NSManaged var priority: NSNumber?
    @NSManaged var status: String?
    @NSManaged var dateOfCreation: NSDate?
    @NSManaged var details: String?
    @NSManaged var taskRelationship: NSSet?

}
