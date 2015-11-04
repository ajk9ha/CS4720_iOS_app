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
import Foundation
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    //Mark: Properties
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var songText: UITextField!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var Lon: UILabel!
    @IBOutlet weak var Proximity: UILabel!
    
    var appDelegate: AppDelegate?
    var locationManager: CLLocationManager?
    var songInfoText = ""
    var eventStore = EKEventStore()
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        lat.text = "Latitude:"+String(newLocation.coordinate.latitude)
        Lon.text = "Longitude:"+String(newLocation.coordinate.longitude)
        
        let loc = CLLocation(latitude: 38.041959, longitude:-78.503392)
        if(newLocation.distanceFromLocation(loc)>5000){
        Proximity.text = "You are \n" + String( round(newLocation.distanceFromLocation(loc))) + "\n meters from the station, that's too far!"
        }
        else{
            Proximity.text = "You are only \n" + String( round(newLocation.distanceFromLocation(loc))) + "\n meters from the station.  Tune in!!!"
        }
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
            
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        songText.delegate = self
        artistText.delegate = self
        do {
            let path = NSTemporaryDirectory() + "savedText.txt"
            let readString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            outputText.text = readString }
            catch let error as NSError {
            outputText.text = "No file saved yet!"
            print(error)
        }
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: true)
                if let manager = self.locationManager{
                    manager.requestAlwaysAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
               locationManager?.requestAlwaysAuthorization()
            }
         locationManager?.requestLocation()
    }
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
        outputText.text = songInfoText
        
        let someText = songText.text! + " by " + artistText.text!
        let destinationPath = NSTemporaryDirectory()+"savedText.txt"
        do {
            try someText.writeToFile(destinationPath,atomically: true,encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("An error occurred: \(error)") }
    }
        
    
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

