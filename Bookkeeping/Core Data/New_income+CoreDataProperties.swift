//
//  New_income+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 12.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//
//

import Foundation
import CoreData


extension New_income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<New_income> {
        return NSFetchRequest<New_income>(entityName: "New_income")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var value: Int32
    @NSManaged public var name_invoice: String?
    @NSManaged public var incomes: Incomes?

}
