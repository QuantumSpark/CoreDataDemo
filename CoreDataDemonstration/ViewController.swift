//
//  ViewController.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-09-28.
//  Copyright © 2016 James Park. All rights reserved.
//

import UIKit
import CoreData

class ViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var teamTable: UITableView!

    
    var selectedMember:Member!
    @IBAction func AddANewMember(sender: AnyObject) {
        self.performSegueWithIdentifier("addANewMember", sender: self)
    }
    var fetchResultController: NSFetchedResultsController!
    
    let coreData = CoreDataHelper()
    var sortDescriptor = [NSSortDescriptor]()
    var filterPredicate: NSPredicate?
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fillInInformation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillInInformation () {
        
        
        let request = NSFetchRequest(entityName: "Member")
        request.predicate = filterPredicate
        let sort = NSSortDescriptor(key: "name", ascending:  true)
        request.sortDescriptors = [sort]
        fetchResultController = NSFetchedResultsController(fetchRequest: request,managedObjectContext: coreData.managedObjectContext, sectionNameKeyPath: nil, cacheName:  nil )
        
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            self.teamTable.reloadData()
            
        }
        catch let error as NSError {
            print(error)
        }
        
    }
    
    private func searchByName (searchPredicate:NSPredicate) {
        
        var predicates = [NSPredicate]()
        predicates.append(searchPredicate)
        if let additionalPredicate = filterPredicate  {
            predicates.append(additionalPredicate)
        }
        let finalPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
        
        let request = NSFetchRequest(entityName: "Member")
        let sort = NSSortDescriptor(key: "name", ascending:  true)
        request.predicate = finalPredicate
        request.sortDescriptors = [sort]
        
        
        fetchResultController = NSFetchedResultsController(fetchRequest: request,managedObjectContext: coreData.managedObjectContext, sectionNameKeyPath: nil, cacheName:  nil )
        
        do {
            try fetchResultController.performFetch()
            self.teamTable.reloadData()
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchResultController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let member = fetchResultController.objectAtIndexPath(indexPath) as? Member
            
            let confirmDeleteAlertController = UIAlertController(title:"Removing a member", message: "Are you sure you want to remove \(member!.name!) from  Launch Pad", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let  deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
                {(action:UIAlertAction) -> Void in
                    self.coreData.managedObjectContext.deleteObject(member!)
                    self.coreData.saveContext()
                    
                }
            )
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:
                {(action:UIAlertAction) -> Void in
                    
                    
                }
            )
            
            confirmDeleteAlertController.addAction(deleteAction)
            confirmDeleteAlertController.addAction(cancelAction)
            presentViewController(confirmDeleteAlertController, animated: true, completion: nil)
            
        } else if editingStyle == .Insert {
            
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMember = fetchResultController.objectAtIndexPath(indexPath) as! Member
        
        performSegueWithIdentifier("EditMember", sender: self)
        
        
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell =  tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MemberTableViewCell
        
        let member = fetchResultController.objectAtIndexPath(indexPath) as! Member
        cell.name.text = member.name
        cell.joinedDate.text = member.dateJoined?.description
        cell.teamName.text = member.teamName
        
        return cell
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (!searchText.isEmpty) {
            let predicate =  NSPredicate(format:"name beginswith[c] %@", searchText)
            self.searchByName(predicate)
        } else {
            fillInInformation()
        }
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        teamTable.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        teamTable.endUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.Delete:
            print("NSFetchedResultsChangeType.Delete detected")
            if let deleteIndexPath = indexPath {
                teamTable.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        case NSFetchedResultsChangeType.Insert:
            print("NSFetchedResultsChangeType.Insert detected")
        case NSFetchedResultsChangeType.Move:
            print("NSFetchedResultsChangeType.Move detected")
        case NSFetchedResultsChangeType.Update:
            print("NSFetchedResultsChangeType.Update detected")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EditMember") {
            let viewController:EditMemberController = segue.destinationViewController as! EditMemberController
            print(selectedMember.name!)
            viewController.tmpName = selectedMember.name!
            viewController.techLead = Bool(selectedMember.techLead!)
            viewController.selectedTeam = selectedMember.teamName!
        } else if (segue.identifier == "segueFilter") {
            sortDescriptor = []
            filterPredicate = nil
            
            let controller = segue.destinationViewController as! FilterViewController
            controller.filterPredicate = nil
            
           

        }
        
    }
    
}




