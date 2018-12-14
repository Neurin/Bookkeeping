//
//  CostsVC.swift
//  Bookkeeping
//
//  Created by Name on 30.09.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit
import CoreData

class CostsVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var costValueTF: UITextField!
    @IBOutlet weak var choiceInvoiceTF: UITextField!
    @IBOutlet weak var collectionCategory: UICollectionView!
    @IBOutlet weak var sumLable: UILabel!
    @IBOutlet weak var costsTV: UITableView!
    
    var fetchDataNewCost: NSFetchedResultsController<NSFetchRequestResult>!
    var fetchDataCollectionCosts = [Costs]()
    var fetchDataInvoice = [Invoice]()
    
    var pikerView = UIPickerView()
    var sumValueCosts = Int32()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate()
        doneButtonToolBar()
        
        // узнать как оновлять viewDidLoad при открытии
        initFetchRequestInvoice()
        initFetchRequestNewCosts()
        initFetchRequestCollectionCosts()
        
        costValueTF.keyboardType = UIKeyboardType.numberPad
        choiceInvoiceTF.inputView = pikerView
        
        
    }
    
    //MARK: Delegate
    func delegate() {
        costValueTF.delegate = self
        choiceInvoiceTF.delegate = self
        self.collectionCategory.delegate = self
        self.collectionCategory.dataSource = self
        pikerView.delegate = self
        pikerView.dataSource = self
        
    }
    
    //MARK: Fetch request
    // Fetch request new cost
    func initFetchRequestNewCosts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "New_cost")
        
        //посмотреть есть ли более лучшие решение
        let date = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, . month, .day, .hour, .minute, .second], from: date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        components.hour = 00
        components.minute = 00
        components.second = 00
        let starDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date =< %@", argumentArray: [starDate!, endDate!])
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchDataNewCost = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataSrack.instance.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchDataNewCost.delegate = self
        
        do {
            try fetchDataNewCost.performFetch()
        } catch {
            fatalError("Failed to init FetchRequestNewCosts: \(error)")
        }
    }
    
    // Fetch request collection costs category
    func initFetchRequestCollectionCosts(){
        let fetchRequest = NSFetchRequest<Costs>(entityName: "Costs")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchDataCollectionCosts = try CoreDataSrack.instance.managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to init FetchRequestCollectionCosts: \(error)")
        }
    }
    
    // Fetch request invoce
    func initFetchRequestInvoice() {
        let fetchRequest = NSFetchRequest<Invoice>(entityName: "Invoice")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchDataInvoice = try CoreDataSrack.instance.managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to init initFetchRequestInvoice: \(error)")
        }
    }
    
    //MARK: Text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    
    func doneButtonToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
    
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneCliked))
        
        toolBar.setItems([flexSpace, doneButton], animated: false)
        
        costValueTF.inputAccessoryView = toolBar
        choiceInvoiceTF.inputAccessoryView = toolBar
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 7
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let charactersSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: charactersSet)
    }
    
    @objc func doneCliked(){
        view.endEditing(true)
    }
    
    //MARK: Piker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        oneInvoice()
        return fetchDataInvoice.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fetchDataInvoice[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choiceInvoiceTF.text = fetchDataInvoice[row].name
    }
    
    func oneInvoice() {
        if fetchDataInvoice.count == 1 {
            choiceInvoiceTF.text = fetchDataInvoice[0].name
        } else {
            choiceInvoiceTF.text = ""
        }
    }
    
    //MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchDataCollectionCosts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCostsCVC
        
        if indexPath.row == fetchDataCollectionCosts.count {
            cell.imageCategoryCost.image = UIImage(named: "PieChart")
            cell.nameCategoryCost.text = "All"
        } else {
            cell.imageCategoryCost.image = UIImage(named: fetchDataCollectionCosts[indexPath.row].image_name!)
            cell.nameCategoryCost.text = fetchDataCollectionCosts[indexPath.row].name
        }
         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == fetchDataCollectionCosts.count {
            self.performSegue(withIdentifier: "NewCategoryCosts", sender: nil)
        } else if costValueTF.text == "" || choiceInvoiceTF.text == ""{
            alertController()
        } else {
            addNewCostInDataBase(index: indexPath)
            updateInvoice()
            oneInvoice()
            costValueTF.text = ""
            print("Save new record in database")
            
        }
    }
    
    //triggered when incorrectly filled fields of the amount of money and account selection
    func alertController(){
        let alertController = UIAlertController(title: "", message: "Заполните все поля правильно", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ясно", style: .default) { (action) in }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addNewCostInDataBase(index: IndexPath) {
        let newCost = New_cost(context: CoreDataSrack.instance.managedContext)
        
        newCost.value = Int32(costValueTF.text!)!
        newCost.name_invoice = choiceInvoiceTF.text
        newCost.date = dateFormat(date: Date())
        fetchDataCollectionCosts[index.row].addToNew_costs(newCost)
        
        CoreDataSrack.instance.saveContext()
    }
    
    func updateInvoice() {
        initFetchRequestInvoice()
        for search in fetchDataInvoice {
            if search.name == choiceInvoiceTF.text {
                search.setValue(search.value - Int32(costValueTF.text!)!, forKey: "Invoice")
                CoreDataSrack.instance.saveContext()
            }
        }
    }
    
    // date formatter
    
    func dateFormat(date: Date) -> NSDate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        
        return calendar.date(from: components)! as NSDate
    }
    
    //MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowInSection = fetchDataNewCost.sections else { return 0 }
        return rowInSection[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCosts", for: indexPath) as! CostsTVC
        let costData = fetchDataNewCost.object(at: indexPath) as! New_cost
        
        sumValueCosts += costData.value
        sumLable.text = "Потрачено сегодня: \(String(sumValueCosts))"
        
        cell.nameCategory.text = costData.costs?.name
        cell.valueCost.text = String(costData.value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Чуть позже delete")
        if editingStyle == .delete {
            initFetchRequestInvoice()
            for search in fetchDataInvoice {
                if search.name == choiceInvoiceTF.text {
                    search.setValue(search.value - Int32(costValueTF.text!)!, forKey: "Invoice")
                    CoreDataSrack.instance.saveContext()
                }
            }
            
            let costData = fetchDataNewCost.object(at: indexPath) as! New_cost
            sumValueCosts -= costData.value
            sumLable.text = "Потрачено сегодня: \(String(sumValueCosts))"
            
            let costDataDelete = fetchDataNewCost.object(at: indexPath)
            CoreDataSrack.instance.managedContext.delete(costDataDelete as! NSManagedObject)
            CoreDataSrack.instance.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditCost", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCosts" {
            let sendIndexPathRow = segue.destination as! EditCostVC
            sendIndexPathRow.indexPathEditCosts = (costsTV.indexPathForSelectedRow)!
        }
    }
    
    //Controller Table view
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        costsTV.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            costsTV.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            costsTV.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            costsTV.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            costsTV.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        costsTV.endUpdates()
    }
    
}

