//
//  AddMemberController.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-09-30.
//  Copyright © 2016 James Park. All rights reserved.
//

import UIKit
import CoreData
class AddMemberController: UIViewController, UIPickerViewDelegate {
    
    let coreData = CoreDataHelper()
    @IBOutlet weak var team: UIPickerView!
    
    @IBOutlet weak var isHeTechLead: UISwitch!
    
    @IBOutlet weak var name: UITextField!
    
    var pickerOptionTeam = ["ios", "android" , "javascript"]
    var selectedTeam = "ios"
    @IBAction func AddMember(sender: AnyObject) {
        
        if (name.text != nil && !(name.text?.isEmpty)!) {
            
            let newMember = NSEntityDescription.insertNewObjectForEntityForName("Member", inManagedObjectContext: coreData.managedObjectContext) as! Member
            newMember.name = name.text
            newMember.teamName = selectedTeam
            newMember.techLead = NSNumber(bool:isHeTechLead.on)
            newMember.dateJoined = NSDate()
            coreData.saveContext()
            self.performSegueWithIdentifier("gobackToMembers", sender: self)
            
        } else {
             let confirmDeleteAlertController = UIAlertController(title:"Empty field", message: "Fill in the name", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
                {(action:UIAlertAction) -> Void in
                    
                    
                }
            )
            
            confirmDeleteAlertController.addAction(okAction)
            presentViewController(confirmDeleteAlertController, animated: true, completion: nil)
            
        }
        
        
    }
    
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
