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
    let flagIncome = UserDefaults.standard.object(forKey: "CheckCreateCategoryIncomes") as? Bool
    let flagPurse = UserDefaults.standard.object(forKey: "CheckCreateCategoryInvoice") as? Bool
    
    
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
    
    func createCategoryIncomes () {
        if flagIncome == false || flagIncome == nil {
            
            let category = Incomes(context: CoreDataSrack.instance.managedContext)
            category.name = "Зарплата"
            category.image_name = "money"
            
            let category2 = Incomes(context: CoreDataSrack.instance.managedContext)
            category2.name = "Бизнес"
            category2.image_name = "briefcase"
            
            let category3 = Incomes(context: CoreDataSrack.instance.managedContext)
            category3.name = "Подработка"
            category3.image_name = "carpenter"
            
            let category4 = Incomes(context: CoreDataSrack.instance.managedContext)
            category4.name = "Подарки"
            category4.image_name = "present"
            
            CoreDataSrack.instance.saveContext()
            
            UserDefaults.standard.set(true, forKey: "CheckCreateCategoryIncomes")
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
    
}
