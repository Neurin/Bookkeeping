//
//  Icone_costs+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 15.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//
//

import Foundation
import CoreData


extension Icone_costs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Icone_costs> {
        return NSFetchRequest<Icone_costs>(entityName: "Icone_costs")
    }

    @NSManaged public var image_name: String?
    @NSManaged public var index: Int16

}
