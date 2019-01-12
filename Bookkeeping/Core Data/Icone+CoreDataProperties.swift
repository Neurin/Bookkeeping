//
//  Icone+CoreDataProperties.swift
//  Bookkeeping
//
//  Created by Name on 15.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//
//

import Foundation
import CoreData


extension Icone {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Icone> {
        return NSFetchRequest<Icone>(entityName: "Icone")
    }

    @NSManaged public var image_name: String?
    @NSManaged public var index: Int16

}
