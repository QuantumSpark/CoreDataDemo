//
//  AppDelegate.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-09-28.
//  Copyright © 2016 James Park. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            
        // Override point for customization after application launch.
        checkDataStore()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkDataStore() {
        let coreData = CoreDataHelper()
        let request = NSFetchRequest(entityName: "Member")
        
        let memberCount = coreData.managedObjectContext.countForFetchRequest(request, error: nil)
        print("There are \(memberCount) members")
        
        if memberCount == 0 {
            uploadeCurrentMembers()
        }
    }
    
    func uploadeCurrentMembers() {
        
        let coreData = CoreDataHelper()
        
        let jsonFilePath = NSBundle.mainBundle().URLForResource("LaunchPadMembers", withExtension: "json")!
        let data = NSData(contentsOfURL: jsonFilePath)
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let iosArray = jsonResult.valueForKey("ios") as! NSArray
            
            for json in iosArray {
                let iosMember = NSEntityDescription.insertNewObjectForEntityForName("Member", inManagedObjectContext: coreData.managedObjectContext) as! Member
                iosMember.teamName = "ios"
                iosMember.name = json["name"] as? String
                let dateString = json["DateJoined"] as? String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss ZZ"
                let date = dateFormatter.dateFromString(dateString!)
                iosMember.dateJoined =  date
                
                let isTechLead = json["techLead"] as! Bool
                
                iosMember.techLead = NSNumber(bool:isTechLead)
                coreData.saveContext()

            }
            
            let androidArray = jsonResult.valueForKey("android") as! NSArray
            
            for json in androidArray {
                let androidMember = NSEntityDescription.insertNewObjectForEntityForName("Member", inManagedObjectContext: coreData.managedObjectContext) as! Member
                androidMember.teamName = "android"
                androidMember.name = json["name"] as? String
                let dateString = json["DateJoined"] as? String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss ZZ"
                let date = dateFormatter.dateFromString(dateString!)
                androidMember.dateJoined =  date
                
                let isTechLead = json["techLead"] as! Bool
                
                androidMember.techLead = NSNumber(bool:isTechLead)
                coreData.saveContext()
            }
            
            
            let javascriptArray = jsonResult.valueForKey("javascript") as! NSArray
            
            for json in javascriptArray {
                let javaScriptMember = NSEntityDescription.insertNewObjectForEntityForName("Member", inManagedObjectContext: coreData.managedObjectContext) as! Member
                javaScriptMember.teamName = "javascript"
                javaScriptMember.name = json["name"] as? String
                let dateString = json["DateJoined"] as? String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss ZZ"
                let date = dateFormatter.dateFromString(dateString!)
                javaScriptMember.dateJoined =  date
                
                let isTechLead = json["techLead"] as! Bool
                
                javaScriptMember.techLead = NSNumber(bool:isTechLead)
                coreData.saveContext()
            }
            
            
        }catch let error as NSError {
            print(error)
        }
        
    }
    
}

