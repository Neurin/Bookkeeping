//
//  EditPlanVC.swift
//  Bookkeeping
//
//  Created by Name on 09.01.2019.
//  Copyright © 2019 Name. All rights reserved.
//

import UIKit
import CoreData

class EditPlanVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var namePlan: UITextField!
    @IBOutlet weak var valuePlan: UITextField!
    @IBOutlet weak var datePlan: UIDatePicker!
    
    var fetchDataPlans = [Plans]()
    
    var sendIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        closeKeyboard()
        initFetchDataPlans()
        
        valuePlan.keyboardType = UIKeyboardType.numberPad
        
        namePlan.text = fetchDataPlans[sendIndexPath.row].name
        valuePlan.text = String(fetchDataPlans[sendIndexPath.row].value)
    }
    
    func delegate() {
        namePlan.delegate = self
        valuePlan.delegate = self
        
    }
    
    //MARK: fetch request
    func initFetchDataPlans() {
        let fetchRequest = NSFetchRequest<Plans>(entityName: "Plans")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchDataPlans = try CoreDataSrack.instance.managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to initFetchDataPlans: \(error)")
        }
    }
    
    //MARK: Text field
    func closeKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == valuePlan {
            let maxLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            let set = NSCharacterSet(charactersIn: "0123456789").inverted
            let checkString = string.components(separatedBy: set)
            let numFilter = checkString.joined(separator: "")
            
            return (newString.length <= maxLength && string == numFilter)
        } else {
            return true
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveNewPlan(_ sender: Any) {
        if namePlan.text == "" {
            alertController()
        } else {
            fetchDataPlans[sendIndexPath.row].name = namePlan.text
            if valuePlan.text != "" {
                fetchDataPlans[sendIndexPath.row].value = Int32(valuePlan.text!)!
            } else {
                fetchDataPlans[sendIndexPath.row].value = 0
            }
            fetchDataPlans[sendIndexPath.row].date = datePlan.date as NSDate
//            fetchDataPlans[sendIndexPath.row].info = not now
            CoreDataSrack.instance.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func alertController(){
        let alertController = UIAlertController(title: "", message: "Заполните все поля правильно", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ясно", style: .default) { (action) in }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}
