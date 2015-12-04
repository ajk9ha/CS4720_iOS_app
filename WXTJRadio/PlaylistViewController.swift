//
//  PlaylistViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 11/4/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit
import EventKit


class PlaylistViewController: UIViewController, UIWebViewDelegate {

    var appDelegate: AppDelegate?

    
    @IBOutlet weak var playlistView: UIWebView!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    var eventStore = EKEventStore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reminder"
        
//        let playlistUrl = NSURL(string: "http://www.wtju.net/player/?station=wtjx")
//        let request = NSURLRequest(URL: playlistUrl!)
//        playlistView.loadRequest(request)

    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            RadioStream.sharedInstance.toggle()
        }
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func playlistViewDidStartLoad(playlistView: UIWebView){
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//    }
//    
//    func playlistViewDidFinishLoad(playlistView: UIWebView){
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//    }
//    
//    func playlistView(playlistView: UIWebView, didFailLoadWithError error: NSError?){
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        /* Render the web view under the status bar */
//        var frame = view.bounds
//        frame.origin.y = UIApplication.sharedApplication().statusBarFrame.height
//        frame.size.height -= frame.origin.y
//        
//        let playlistView = UIWebView(frame: frame)
//        playlistView.delegate = self
//        playlistView.scalesPageToFit = true
//        view.addSubview(playlistView)
//        
//        let url = NSURL(string: "http://www.wtju.net/player/?station=wtjx")
//        let request = NSURLRequest(URL: url!)
//        
//        playlistView.loadRequest(request)
//        
//        view.addSubview(playlistView)
//        
//    }
//    
//}


}
