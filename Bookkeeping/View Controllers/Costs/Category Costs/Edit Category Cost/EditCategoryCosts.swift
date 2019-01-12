//
//  EditCategoryCosts.swift
//  Bookkeeping
//
//  Created by Name on 15.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit
import CoreData

class EditCategoryCosts: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var indexPathEditCategory = [IndexPath]()
    
    @IBOutlet weak var editNameCategory: UITextField!
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    var fetchDataCollectionCosts = [Costs]()
    var fetchDataIconeCosts = [Icone_costs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate()
        
        initFetchRequestCollectionCosts()
        initFetchRequestIconeCosts()
        
        closeKeyboard()
        
        editNameCategory.text = fetchDataCollectionCosts[indexPathEditCategory[0].row].name
    }
    
    func delegate() {
        collectionCategory.delegate = self
        collectionCategory.dataSource = self
        editNameCategory.delegate = self
    }
    
    //MARK: fetch request
    // Fetch request collection costs category
    func initFetchRequestCollectionCosts(){
        let fetchRequest = NSFetchRequest<Icone_costs>(entityName: "Icone_costs")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchDataIconeCosts = try CoreDataSrack.instance.managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to init FetchRequestCollectionCosts: \(error)")
        }
    }
    
    
    func initFetchRequestIconeCosts(){
        let fetchRequest = NSFetchRequest<Costs>(entityName: "Costs")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            fetchDataCollectionCosts = try CoreDataSrack.instance.managedContext.fetch(fetchRequest)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditCategoryCosts", for: indexPath) as! EditCategoryCostsCVC
        
        cell.imageCategoryCost.image = UIImage(named: fetchDataIconeCosts[indexPath.row].image_name!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editNameCategory.text == "" {
            alertController()
        } else {
            fetchDataCollectionCosts[indexPathEditCategory[0].row].name = editNameCategory.text
            fetchDataCollectionCosts[indexPathEditCategory[0].row].image_name = fetchDataIconeCosts[indexPath.row].image_name
            CoreDataSrack.instance.saveContext()
            editNameCategory.text = ""
            NotificationCenter.default.post(name: NSNotification.Name("ReloadDataCategoryCosts"), object: nil)
            navigationController?.popViewController(animated: true)
        }
    }

    func alertController(){
        let alertController = UIAlertController(title: "", message: "Заполните поле названия категории", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ясно", style: .default) { (action) in }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteCategory(_ sender: Any) {
        CoreDataSrack.instance.managedContext.delete(fetchDataCollectionCosts[indexPathEditCategory[0].row])
        CoreDataSrack.instance.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("ReloadDataCategoryCosts"), object: nil)
        navigationController?.popViewController(animated: true)
    }
}
