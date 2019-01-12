//
//  AllCategoryCostsVC.swift
//  Bookkeeping
//
//  Created by Name on 14.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit
import CoreData

class AllCategoryCostsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionCategory: UICollectionView!
    
    var fetchDataCollectionCosts = [Costs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate()
        
        initFetchRequestCollectionCosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategory), name: NSNotification.Name("ReloadDataCategoryCosts"), object: nil)
    }
    
    func delegate() {
        collectionCategory.delegate = self
        collectionCategory.dataSource = self
    }
    
    //MARK: fetch request
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchDataCollectionCosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCosts", for: indexPath) as! AllCategoryCostsCVC
        
        cell.imageCategoryCost.image = UIImage(named: fetchDataCollectionCosts[indexPath.row].image_name!)
        cell.nameCategoryCost.text = fetchDataCollectionCosts[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditCategoryCost", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCategoryCost" {
            let sendIndexPath = segue.destination as! EditCategoryCosts
            sendIndexPath.indexPathEditCategory = collectionCategory.indexPathsForSelectedItems!
        }
    }
    
    @objc func updateCategory() {
        initFetchRequestCollectionCosts()
        collectionCategory.reloadData()
    }
}
