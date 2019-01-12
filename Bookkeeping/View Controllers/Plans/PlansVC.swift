//
//  PlansVC.swift
//  Bookkeeping
//
//  Created by Name on 09.01.2019.
//  Copyright © 2019 Name. All rights reserved.
//

import UIKit
import CoreData

class PlansVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tablePlans: UITableView!
    
    var fetchDataPlans: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate()
        initFetchDataPlans()
        
    }
    
    func delegate() {
        tablePlans.delegate = self
        tablePlans.dataSource = self
    }

    //MARK: Fetch request
    func initFetchDataPlans() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plans")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchDataPlans = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataSrack.instance.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchDataPlans.delegate = self
        
        do {
            try fetchDataPlans.performFetch()
        } catch {
            fatalError("Failed to initFetchDataPlans: \(error)")
        }
    }
    //MARK: Table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataPlans = fetchDataPlans.sections else { return 0 }
        return dataPlans[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlansCell", for: indexPath) as! PlansTVC
        let dataPlans = fetchDataPlans.object(at: indexPath) as! Plans
        
        cell.namePlan.text = dataPlans.name
        cell.valueCosts.text = ("Расходы: \(String(dataPlans.value))")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditPlan", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlan" {
            let sendIndexPathPlan = segue.destination as! EditPlanVC
            sendIndexPathPlan.sendIndexPath = tablePlans.indexPathForSelectedRow!
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataSrack.instance.managedContext.delete(fetchDataPlans.object(at: indexPath) as! NSManagedObject)
            CoreDataSrack.instance.saveContext()
        }
    }
    
    //Controller Table view
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tablePlans.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tablePlans.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tablePlans.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tablePlans.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tablePlans.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tablePlans.endUpdates()
    }
}
