//
//  NewCategoryCosts.swift
//  Bookkeeping
//
//  Created by Name on 12.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit
import CoreData

class NewCategoryCosts: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var newNameCategoryCost: UITextField!
    @IBOutlet weak var collectionCategory: UICollectionView!
    var fetchDataIconeCosts = [Icone_costs]()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate()
        initFetchRequestIconeCosts()
        closeKeyboard()
    }
    
    func delegate() {
        newNameCategoryCost.delegate = self
        collectionCategory.delegate = self
        collectionCategory.dataSource = self
    }
    
    //MARL: Fetch request
    // Fetch request collection costs category
    func initFetchRequestIconeCosts(){
        let fetchRequest = NSFetchRequest<Icone_costs>(entityName: "Icone_costs")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchDataIconeCosts = try CoreDataSrack.instance.managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to init FetchRequestCollectionCosts: \(error)")
        }
    }
    
    //MARK: Text field
    func closeKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 9
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchDataIconeCosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewCategoryCosts", for: indexPath) as! NewCategoryCostsCVC
        
        cell.imageCategoryCost.image = UIImage(named: fetchDataIconeCosts[indexPath.row].image_name!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if newNameCategoryCost.text == "" {
            alertController()
        } else {
            let newCategoryCosts = Costs(context: CoreDataSrack.instance.managedContext)
            newCategoryCosts.image_name = fetchDataIconeCosts[indexPath.row].image_name
            newCategoryCosts.index = Int16(fetchDataIconeCosts.count) + 1 //bad
            newCategoryCosts.name = newNameCategoryCost.text
            CoreDataSrack.instance.saveContext()
            newNameCategoryCost.text = ""
            NotificationCenter.default.post(name: NSNotification.Name("ReloadDataCategoryCosts"), object: nil)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func alertController(){
        let alertController = UIAlertController(title: "", message: "Заполните поле названия новой категории", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ясно", style: .default) { (action) in }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
