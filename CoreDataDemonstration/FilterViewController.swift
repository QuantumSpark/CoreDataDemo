//
//  FilterViewController.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-10-01.
//  Copyright © 2016 James Park. All rights reserved.
//

import UIKit
import CoreData

class FilterViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var FilterPicker: UIPickerView!
    var filterPredicate: NSPredicate?
    let filterPickerOption = ["All","TechLead","ios", "android" , "javascript"];
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterPickerOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterPickerOption[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (filterPickerOption[row] == "TechLead") {
            sortByTechLead()
        } else if (filterPickerOption[row] == "All"){
            filterPredicate = nil
        } else {
            sortByTeam(filterPickerOption[row])
        }
        
       
    }
    
    private func sortByTechLead () {
        filterPredicate = NSPredicate(format: "techLead = true")
    }
    
    private func sortByTeam (teamName : String) {
        filterPredicate = NSPredicate(format:"teamName = %@", teamName)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "backFromFilter") {
            let controller = segue.destinationViewController as! ViewController
            controller.filterPredicate = filterPredicate
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
