//
//  InvoiceVC.swift
//  Bookkeeping
//
//  Created by Name on 24.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit
import CoreData

class InvoiceVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableViewInvoice: UITableView!
    
    var fetchDataInvoice: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
    
        tableViewInvoice.delegate = self
        tableViewInvoice.dataSource = self
        
        initFetchRequestInvoice()
        
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
            fatalError("Failed to initFetchRequestInvoice: \(error)")
        }
    }
    
    
    //MARK: Table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataInvoice = fetchDataInvoice.sections else { return 0 }
        return dataInvoice[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellInvoice", for: indexPath) as! InvoiceTVC
        let dataInvoice = fetchDataInvoice.object(at: indexPath) as! Invoice
        
        cell.nameInvoice.text = dataInvoice.name
        cell.valueInvoice.text = String(dataInvoice.value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            CoreDataSrack.instance.managedContext.delete(fetchDataInvoice.object(at: indexPath) as! NSManagedObject)
            CoreDataSrack.instance.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name("ReloadDataInvoice"), object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditInvoice", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditInvoice" {
            let dataSend = segue.destination as! EditInvoiceVC
            dataSend.indexInvoice = tableViewInvoice.indexPathForSelectedRow!
        }
    }
    
    //Controller Table view
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewInvoice.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableViewInvoice.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableViewInvoice.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableViewInvoice.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableViewInvoice.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewInvoice.endUpdates()
    }
    
}
