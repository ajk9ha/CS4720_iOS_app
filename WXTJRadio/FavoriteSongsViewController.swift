//
//  FavoriteSongsViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 10/18/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit
import EventKit
import CoreData
class FavoriteSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var playListEntry: UITextView!
    var eventStore = EKEventStore()
    @IBOutlet weak var PlayListTable: UITableView!
    var songs = [NSManagedObject]()

    
    var appDelegate: AppDelegate?
    
    var playlistText = "Initial Value"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayListTable.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        PlayListTable.delegate = self

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Code for setting up the Alarm notification, which calls createReminder */
    @IBAction func setReminder(sender: UIButton) {
        
        appDelegate = UIApplication.sharedApplication().delegate
            as? AppDelegate
        if appDelegate!.eventStore == nil {
            appDelegate!.eventStore = EKEventStore()
            appDelegate!.eventStore!.requestAccessToEntityType(
                EKEntityType.Reminder, completion: {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                        print(error!.localizedDescription)
                    } else {
                        print("Access granted")
                    }
            })
        }
        
        if (appDelegate!.eventStore != nil) {
            self.createReminder()
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("HERE")
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(songs[indexPath.row] as NSManagedObject)
        songs.removeAtIndex(indexPath.row)
        do {
            try managedContext.save()
            //5
            self.PlayListTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Song")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            songs = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    /* Code for setting the details of the alarm notification */
    func createReminder() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        eventStore.requestAccessToEntityType(EKEntityType.Reminder,
            completion: {(granted: Bool, error:NSError?) in
                if !granted {
                    print("Access to store not granted")
                }
        })
        
        let reminder = EKReminder(eventStore: appDelegate!.eventStore!)
        reminder.title = "Don't forget to tune into your favorite show!"
        reminder.calendar = appDelegate!.eventStore!.defaultCalendarForNewReminders()
        
        print("reminder: \(reminder)")

        
        let date = reminderDatePicker.date
        print("date: \(date)")
        
        let alarm = EKAlarm(absoluteDate: date)
        
        reminder.addAlarm(alarm)
        
        do {
            try appDelegate!.eventStore!.saveReminder(reminder, commit:true)
        } catch {
            return
        }
        
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            RadioStream.sharedInstance.toggle()
        }
    }

    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return songs.count
    }
    
     func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            let song = songs[indexPath.row]
            
            cell!.textLabel!.text =
                song.valueForKey("title") as? String
            
            return cell!
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
