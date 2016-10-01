//
//  Team+CoreDataProperties.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-09-28.
//  Copyright © 2016 James Park. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Team {

    @NSManaged var name: String?
    @NSManaged var members: NSSet?

}
