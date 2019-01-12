//
//  EditInvoiceVC.swift
//  Bookkeeping
//
//  Created by Name on 25.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit
import CoreData

class EditInvoiceVC: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameInvoice: UITextField!
    @IBOutlet weak var valueInvoice: UITextField!
    
    var indexInvoice = IndexPath()
    var fetchDataInvoice: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameInvoice.delegate = self
        valueInvoice.delegate = self
        
        initFetchRequestInvoice()
        closeKeyboard()
        
        valueInvoice.keyboardType = UIKeyboardType.numberPad
        
        let dataInvoice = fetchDataInvoice.object(at: indexInvoice) as! Invoice
        
        nameInvoice.text = dataInvoice.name
        valueInvoice.text = String(dataInvoice.value)
        
    }
    
    
    //MARK: Fetch request
    func initFetchRequestInvoice() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Invoice")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchDataInvoice = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataSrack.instance.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchDataInvoice.delegate = self
        do {
            try fetchDataInvoice.performFetch()
        } catch {
            fatalError("Failed to init initFetchRequestInvoice: \(error)")
        }
    }

    //MARK: Text field
    func closeKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == valueInvoice {
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
    
    @IBAction func saveEditInvoice(_ sender: Any) {
        let dataInvoice = fetchDataInvoice.object(at: indexInvoice) as! Invoice
        
        if nameInvoice.text == "" || valueInvoice.text == "" {
            alertController()
        } else {
            dataInvoice.name = nameInvoice.text
            dataInvoice.value = Int32(valueInvoice.text!)!
            CoreDataSrack.instance.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name("ReloadDataInvoice"), object: nil)
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
