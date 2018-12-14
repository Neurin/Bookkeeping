//
//  New_cost+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 12.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//
//

import Foundation
import CoreData


extension New_cost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<New_cost> {
        return NSFetchRequest<New_cost>(entityName: "New_cost")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var value: Int32
    @NSManaged public var name_invoice: String?
    @NSManaged public var costs: Costs?

}
