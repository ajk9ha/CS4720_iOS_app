//
//  ViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 10/16/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit
import EventKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {

    //Mark: Properties
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var songText: UITextField!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var appDelegate: AppDelegate?
    
    var songInfoText = ""
    var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        songText.delegate = self
        artistText.delegate = self
        
        playButton.setTitle("Play", forState: UIControlState.Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        toggle()
    
    }
    
    func toggle() {
        if RadioStream.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    func playRadio() {
        RadioStream.sharedInstance.play()
        playButton.setTitle("Pause", forState: UIControlState.Normal)
    }
    
    func pauseRadio() {
        RadioStream.sharedInstance.pause()
        playButton.setTitle("Play", forState: UIControlState.Normal)
        
    }
    
    
//    /* Code for setting up the Alarm notification, which calls createReminder */
//    @IBAction func setReminder(sender: UIButton) {
//        
//        appDelegate = UIApplication.sharedApplication().delegate
//            as? AppDelegate
//        if appDelegate!.eventStore == nil {
//            appDelegate!.eventStore = EKEventStore()
//            appDelegate!.eventStore!.requestAccessToEntityType(
//                EKEntityType.Reminder, completion: {(granted, error) in
//                    if !granted {
//                        print("Access to store not granted")
//                        print(error!.localizedDescription)
//                    } else {
//                        print("Access granted")
//                    }
//            })
//        }
//        
//        if (appDelegate!.eventStore != nil) {
//            self.createReminder()
//        }
//        
//    }
//    
//    /* Code for setting the details of the alarm notification */
//    func createReminder() {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = .MediumStyle
//        
//        eventStore.requestAccessToEntityType(EKEntityType.Reminder,
//            completion: {(granted: Bool, error:NSError?) in
//                if !granted {
//                    print("Access to store not granted")
//                }
//        })
//        
//        let reminder = EKReminder(eventStore: appDelegate!.eventStore!)
//        reminder.title = "Don't forget to tune into your favorite show!"
//        reminder.calendar = appDelegate!.eventStore!.defaultCalendarForNewReminders()
//
//        var date = reminderDatePicker.date
//        print("date: \(date)")
//        
//        let alarm = EKAlarm(absoluteDate: date)
//        
//        reminder.addAlarm(alarm)
//        
//        do {
//            try appDelegate!.eventStore!.saveReminder(reminder, commit:true)
//        } catch {
//            return
//        }
//
//    }

    // Mark: Actions
    @IBAction func setSong(sender: UIButton) {
        songInfoText = songText.text! + " by " + artistText.text!
        outputText.text = songInfoText    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        songInfoText = songText.text! + " by " + artistText.text!
        
        let favoritesView = segue.destinationViewController as! FavoriteSongsViewController
        
        favoritesView.playlistText = songInfoText
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == songText) {
            artistText.becomeFirstResponder()
        }
        
        return true
    }



}

