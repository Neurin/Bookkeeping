//
//  Plans+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 09.01.2019.
//  Copyright © 2019 Name. All rights reserved.
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
    @NSManaged public var value: Int32

}
