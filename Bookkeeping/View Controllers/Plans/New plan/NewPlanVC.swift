//
//  NewPlanVC.swift
//  Bookkeeping
//
//  Created by Name on 09.01.2019.
//  Copyright © 2019 Name. All rights reserved.
//

import UIKit
import CoreData

class NewPlanVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var namePlan: UITextField!
    @IBOutlet weak var valuePlan: UITextField!
    @IBOutlet weak var datePlan: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate()
        closeKeyboard()
        valuePlan.keyboardType = UIKeyboardType.numberPad
    }
    
    func delegate() {
        namePlan.delegate = self
        valuePlan.delegate = self
        
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
            let newPlan = Plans(context: CoreDataSrack.instance.managedContext)
            newPlan.name = namePlan.text
            if valuePlan.text != "" {
              newPlan.value = Int32(valuePlan.text!)!
            } else {
                newPlan.value = 0
            }
            newPlan.date = datePlan.date as NSDate
//            newPlan.info = not now
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
