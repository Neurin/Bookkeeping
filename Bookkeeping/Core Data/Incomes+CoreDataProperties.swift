//
//  Incomes+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 29.11.2018.
//  Copyright © 2018 Name. All rights reserved.
//
//

import Foundation
import CoreData


extension Incomes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Incomes> {
        return NSFetchRequest<Incomes>(entityName: "Incomes")
    }

    @NSManaged public var image_name: String?
    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var new_incomes: NSSet?

}

// MARK: Generated accessors for new_incomes
extension Incomes {

    @objc(addNew_incomesObject:)
    @NSManaged public func addToNew_incomes(_ value: New_income)

    @objc(removeNew_incomesObject:)
    @NSManaged public func removeFromNew_incomes(_ value: New_income)

    @objc(addNew_incomes:)
    @NSManaged public func addToNew_incomes(_ values: NSSet)

    @objc(removeNew_incomes:)
    @NSManaged public func removeFromNew_incomes(_ values: NSSet)

}
