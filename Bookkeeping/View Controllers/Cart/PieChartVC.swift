//
//  PieChartVC.swift
//  Bookkeeping
//
//  Created by Name on 10.01.2019.
//  Copyright © 2019 Name. All rights reserved.
//

import UIKit
import CoreData
import Charts

class PieChartVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var startDayTF: UITextField!
    @IBOutlet weak var endDayTF: UITextField!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var fetchDataCategoryCosts = [Costs]()
    var fetchDataCosts = [New_cost]()
    var dataChart = [PieChartDataEntry]()
    var startDayPiker = Date()
    var endDayPiker = Date()
    var datePiker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate()
        
        initfetchDataCosts()
        initFetchDataCategoryCosts()
        
        closeKeyboard()
        createDatePiker()
        
        startDayTF.text = "\(dateFormat(date: Date()))"
        endDayTF.text = "\(dateFormat(date: Date()))"
        
        dataChartCosts()
        updateDataChart()
    }
    
    func delegate() {
        startDayTF.delegate = self
        endDayTF.delegate = self
    
    }
    
    //MARK: fetch request
    func initFetchDataCategoryCosts() {
        let fetchRequest = NSFetchRequest<Costs>(entityName: "Costs")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            try fetchDataCategoryCosts = CoreDataSrack.instance.managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to initFetchDataCategoryCosts: \(error)")
        }
    }
    
    func initfetchDataCosts() {
        let fetchRequest = NSFetchRequest<New_cost>(entityName: "New_cost")
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startDate(date: startDayPiker), endDate(date: endDayPiker)])
        
        do {
            try fetchDataCosts = CoreDataSrack.instance.managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to initfetchDataCosts: \(error)")
        }
    }
    
    //MARK: Chart
    func dataChartCosts() {
        var sumValue: Double = 0
        
        dataChart.removeAll()
        
        for i in 0..<fetchDataCategoryCosts.count {
            for j in 0..<fetchDataCosts.count {
                if fetchDataCategoryCosts[i].name == fetchDataCosts[j].costs?.name {
                    sumValue += Double(fetchDataCosts[j].value)
                }
            }
            if sumValue != 0 {
                let dataCost = PieChartDataEntry(value: sumValue, label: fetchDataCategoryCosts[i].name)
                dataChart.append(dataCost)
                sumValue = 0
            }
        }
    }
    
    func updateDataChart() {
        let pieChartDataSet = PieChartDataSet(values: dataChart, label: nil)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        var color: [UIColor] = []
        
        for i in 0..<dataChart.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let colors = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            color.append(colors)
        }
        
        pieChartDataSet.colors = color
        
        pieChartView.legend.enabled = false
        pieChartView.chartDescription?.text = ""
        pieChartView.data = pieChartData
    }
    
    //MARK: Text field
    func closeKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: Date  piker
    func createDatePiker(){
        startDayTF.inputView = datePiker
        endDayTF.inputView = datePiker
        
        datePiker.locale = Locale(identifier: "ru_RU")
        datePiker.datePickerMode = .date
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == startDayTF {
            startDayTF.text = "\(dateFormat(date: datePiker.date))"
            startDayPiker = datePiker.date
            updateDataChart()
            datePiker.date = Date()
        } else {
            endDayTF.text = "\(dateFormat(date: datePiker.date))"
            endDayPiker = datePiker.date
            updateDataChart()
            datePiker.date = Date()
        }
        view.endEditing(true)
    }
    
    //MARK: Date formatter
    func dateFormat(date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd MMMM yyyy"
        dateFormatterGet.locale = Locale(identifier: "ru_RU")
        
        return dateFormatterGet.string(from: date)
    }
    
    func startDate(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        
        return startDate!
    }
    
    func endDate(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        
        return endDate!
    }

}
