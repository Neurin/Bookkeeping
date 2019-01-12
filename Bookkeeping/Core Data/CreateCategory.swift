//
//  CreateCategory.swift
//  Bookkeeping
//
//  Created by Name on 30.11.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import Foundation
import CoreData

class CreateCategory {
    
    static let instance = CreateCategory()
    
    init() {}
    
    
    let flagCosts = UserDefaults.standard.object(forKey: "CheckCreateCategoryCosts") as? Bool
    let flagPurse = UserDefaults.standard.object(forKey: "CheckCreateCategoryInvoice") as? Bool
    let flagIcone = UserDefaults.standard.object(forKey: "CheckCreateIconeLists") as? Bool
    let flagIconeCosts = UserDefaults.standard.object(forKey: "CheckCreateIconeCategoryCosts") as? Bool
    
    func createCategoryCosts () {
        if flagCosts == false || flagCosts == nil {
            
            let category = Costs(context: CoreDataSrack.instance.managedContext)
            category.name = "Продукты"
            category.image_name = "products"
            
            let category2 = Costs(context: CoreDataSrack.instance.managedContext)
            category2.name = "Обеды"
            category2.image_name = "dish"
            
            let category3 = Costs(context: CoreDataSrack.instance.managedContext)
            category3.name = "Одежда"
            category3.image_name = "clothes"
            
            let category4 = Costs(context: CoreDataSrack.instance.managedContext)
            category4.name = "Спорт"
            category4.image_name = "sport"
            
            let category5 = Costs(context: CoreDataSrack.instance.managedContext)
            category5.name = "Бензин"
            category5.image_name = "fuel"
            
            let category6 = Costs(context: CoreDataSrack.instance.managedContext)
            category6.name = "Дом"
            category6.image_name = "home"
            
            let category7 = Costs(context: CoreDataSrack.instance.managedContext)
            category7.name = "Отдых"
            category7.image_name = "recreation"
            
            let category8 = Costs(context: CoreDataSrack.instance.managedContext)
            category8.name = "Мобильный"
            category8.image_name = "phone"
            
            let category9 = Costs(context: CoreDataSrack.instance.managedContext)
            category9.name = "Интернет"
            category9.image_name = "internet"
            
            let category10 = Costs(context: CoreDataSrack.instance.managedContext)
            category10.name = "Налоги"
            category10.image_name = "tax"
            
            let category11 = Costs(context: CoreDataSrack.instance.managedContext)
            category11.name = "Другое"
            category11.image_name = "other"
            
            CoreDataSrack.instance.saveContext()
            
            UserDefaults.standard.set(true, forKey: "CheckCreateCategoryCosts")
        }
    }
    
    func createInvoice () {
        if flagPurse == false || flagPurse == nil {
            
            let invoice = Invoice(context: CoreDataSrack.instance.managedContext)
            invoice.name = "Кошелек"
            invoice.index = 0
            invoice.value = 0
            
            CoreDataSrack.instance.saveContext()
            
            UserDefaults.standard.set(true, forKey: "CheckCreateCategoryInvoice")
        }
    }
    
    func createIconeList () {
        if flagIcone == false || flagIcone == nil {
            
            let icone1 = Icone(context: CoreDataSrack.instance.managedContext)
            icone1.index = 1
            icone1.image_name = "products"
            
            let icone2 = Icone(context: CoreDataSrack.instance.managedContext)
            icone2.index = 2
            icone2.image_name = "dish"
            
            let icone3 = Icone(context: CoreDataSrack.instance.managedContext)
            icone3.index = 3
            icone3.image_name = "clothes"
            
            let icone4 = Icone(context: CoreDataSrack.instance.managedContext)
            icone4.index = 4
            icone4.image_name = "sport"
            
            let icone5 = Icone(context: CoreDataSrack.instance.managedContext)
            icone5.index = 5
            icone5.image_name = "fuel"
            
            let icone6 = Icone(context: CoreDataSrack.instance.managedContext)
            icone6.index = 6
            icone6.image_name = "home"
            
            let icone7 = Icone(context: CoreDataSrack.instance.managedContext)
            icone7.index = 7
            icone7.image_name = "recreation"
            
            let icone8 = Icone(context: CoreDataSrack.instance.managedContext)
            icone8.index = 8
            icone8.image_name = "phone"
            
            let icone9 = Icone(context: CoreDataSrack.instance.managedContext)
            icone9.index = 9
            icone9.image_name = "internet"
            
            let icone10 = Icone(context: CoreDataSrack.instance.managedContext)
            icone10.index = 10
            icone10.image_name = "tax"
            
            let icone11 = Icone(context: CoreDataSrack.instance.managedContext)
            icone11.index = 11
            icone11.image_name = "other"
            
            let icone12 = Icone(context: CoreDataSrack.instance.managedContext)
            icone12.index = 12
            icone12.image_name = "money"
            
            let icone13 = Icone(context: CoreDataSrack.instance.managedContext)
            icone13.index = 13
            icone13.image_name = "briefcase"
            
            let icone14 = Icone(context: CoreDataSrack.instance.managedContext)
            icone14.index = 14
            icone14.image_name = "carpenter"
            
            let icone15 = Icone(context: CoreDataSrack.instance.managedContext)
            icone15.index = 15
            icone15.image_name = "present"
            
            CoreDataSrack.instance.saveContext()
            
            UserDefaults.standard.set(true, forKey: "CheckCreateIconeLists")
        }
    }
    
    func createIconeCosts() {
        if flagIconeCosts == false || flagIconeCosts == nil {
            
            let icone1 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone1.index = 1
            icone1.image_name = "products"
            
            let icone2 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone2.index = 2
            icone2.image_name = "dish"
            
            let icone3 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone3.index = 3
            icone3.image_name = "clothes"
            
            let icone4 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone4.index = 4
            icone4.image_name = "sport"
            
            let icone5 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone5.index = 5
            icone5.image_name = "fuel"
            
            let icone6 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone6.index = 6
            icone6.image_name = "home"
            
            let icone7 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone7.index = 7
            icone7.image_name = "recreation"
            
            let icone8 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone8.index = 8
            icone8.image_name = "phone"
            
            let icone9 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone9.index = 9
            icone9.image_name = "internet"
            
            let icone10 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone10.index = 10
            icone10.image_name = "tax"
            
            let icone11 = Icone_costs(context: CoreDataSrack.instance.managedContext)
            icone11.index = 11
            icone11.image_name = "other"
            
            CoreDataSrack.instance.saveContext()
            
            UserDefaults.standard.set(true, forKey: "CheckCreateIconeCategoryCosts")
        }
    }
}
