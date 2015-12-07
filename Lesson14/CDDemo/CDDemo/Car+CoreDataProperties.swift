//
//  Car+CoreDataProperties.swift
//  CDDemo
//
//  Created by miha perne on 30/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Car {

    @NSManaged var make: String?
    @NSManaged var model: String?
    @NSManaged var owner: Person?

}
