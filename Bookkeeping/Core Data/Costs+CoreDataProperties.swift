//
//  Costs+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 29.11.2018.
//  Copyright © 2018 Name. All rights reserved.
//
//

import Foundation
import CoreData


extension Costs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Costs> {
        return NSFetchRequest<Costs>(entityName: "Costs")
    }

    @NSManaged public var image_name: String?
    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var new_costs: NSSet?

}

// MARK: Generated accessors for new_costs
extension Costs {

    @objc(addNew_costsObject:)
    @NSManaged public func addToNew_costs(_ value: New_cost)

    @objc(removeNew_costsObject:)
    @NSManaged public func removeFromNew_costs(_ value: New_cost)

    @objc(addNew_costs:)
    @NSManaged public func addToNew_costs(_ values: NSSet)

    @objc(removeNew_costs:)
    @NSManaged public func removeFromNew_costs(_ values: NSSet)

}
