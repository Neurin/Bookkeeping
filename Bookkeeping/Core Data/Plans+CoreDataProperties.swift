//
//  Plans+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 29.11.2018.
//  Copyright © 2018 Name. All rights reserved.
//
//

import Foundation
import CoreData


extension Plans {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plans> {
        return NSFetchRequest<Plans>(entityName: "Plans")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var type: Bool
    @NSManaged public var value: Int32

}
