//
//  EditCostVC.swift
//  Bookkeeping
//
//  Created by Name on 01.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit
import CoreData

class EditCostVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    var indexPathEditCosts = Int()
    
    @IBOutlet weak var costValueTF: UITextField!
    @IBOutlet weak var choiceInvoiceTF: UITextField!
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    var fetchDataCosts: NSFetchedResultsController<NSFetchRequestResult>!
    var fetchDataCollectionCosts = [Costs]()
    var fetchDataInvoice = [Invoice]()
    
    var pikerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        
        // узнать как оновлять viewDidLoad при открытии
        initFetchRequestInvoice()
        initFetchRequestCosts()
        initFetchRequestCollectionCosts()
        
        costValueTF.keyboardType = UIKeyboardType.numberPad
        choiceInvoiceTF.inputView = pikerView
        doneButtonToolBar()
        
    }
    
    //MARK: Delegate
    func delegate() {
        costValueTF.delegate = self
        choiceInvoiceTF.delegate = self
        collectionCategory.delegate = self
        collectionCategory.dataSource = self
        pikerView.delegate = self
        pikerView.dataSource = self
        
    }
    
    //MARK: Fetch request
    // Fetch request new cost
    func initFetchRequestCosts() {
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
        
        fetchDataCosts = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataSrack.instance.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchDataCosts.delegate = self
        
        do {
            try fetchDataCosts.performFetch()
        } catch {
            fatalError("Failed to init FetchRequestCosts: \(error)")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditCollectionCell", for: indexPath) as! CollectionCostsCVC
        
        if indexPath.row == fetchDataCollectionCosts.count {
            cell.imageCategoryCost.image = UIImage(named: "PieChart")
            cell.nameCategoryCost.text = "Новое"
        } else {
            cell.imageCategoryCost.image = UIImage(named: fetchDataCollectionCosts[indexPath.row].image_name!)
            cell.nameCategoryCost.text = fetchDataCollectionCosts[indexPath.row].name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == fetchDataCollectionCosts.count {
            self.performSegue(withIdentifier: "NewCategoryCostsOfEditCost", sender: nil)
        } else if costValueTF.text == "" || choiceInvoiceTF.text == ""{
            alertController()
        } else {
            EditCostInDataBase(index: indexPath)
            updateInvoice()
            oneInvoice()
            costValueTF.text = ""
            
        }
    }
    
    //triggered when incorrectly filled fields of the amount of money and account selection
    func alertController(){
        let alertController = UIAlertController(title: "", message: "Заполните все поля правильно", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ясно", style: .default) { (action) in }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func EditCostInDataBase(index: IndexPath) {
        let newCost = New_cost(context: CoreDataSrack.instance.managedContext)
        
        newCost.value = Int32(costValueTF.text!)!
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

}
