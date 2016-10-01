//
//  EditMemberController.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-09-30.
//  Copyright © 2016 James Park. All rights reserved.
//

import UIKit
import CoreData

class EditMemberController: UIViewController, UIPickerViewDelegate   {

    @IBOutlet weak var labelForSelectedMember: UILabel!
    @IBOutlet weak var teamPicker: UIPickerView!
    @IBOutlet weak var editedName: UITextField!
    
    @IBOutlet weak var isTechLead: UISwitch!
    let coreData = CoreDataHelper()
    var pickerOptionTeam:[String] = ["ios", "android" , "javascript"]
    var selectedTeam = ""
    var memberName:String?
    var tmpName = ""
    var techLead = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editedName.text = tmpName
        isTechLead.setOn(techLead, animated: true)
        let defaultRowIndex = pickerOptionTeam.indexOf(selectedTeam)
        teamPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }

    @IBAction func EditMember(sender: AnyObject) {
        let request = NSFetchRequest(entityName: "Member")
        request.predicate = NSPredicate(format: "name = %@", tmpName)
        
        do {
            let results = try coreData.managedObjectContext.executeFetchRequest(request) as? [NSManagedObject]
            
            let result = results!.first
            
            
            result?.setValue(editedName.text, forKey: "name")
            result?.setValue(selectedTeam, forKey: "teamName")
            result?.setValue(NSNumber(bool: isTechLead.on), forKey: "techLead")
            
            
            coreData.saveContext()
            
            
        } catch {
            performSegueWithIdentifier("BackToMembersEdit", sender: self)
        }
        
        performSegueWithIdentifier("BackToMembersEdit", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      
        return pickerOptionTeam.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return pickerOptionTeam[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedTeam = pickerOptionTeam[row]
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
