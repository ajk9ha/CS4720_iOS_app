//
//  StreamViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 11/4/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation


class StreamViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var Lon: UILabel!
    @IBOutlet weak var Proximity: UILabel!
    @IBOutlet weak var streamIndicator: UIImageView!
    
    var locationManager: CLLocationManager?
    var distance = 0.0
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
//        lat.text = "Latitude:"+String(newLocation.coordinate.latitude)
//        Lon.text = "Longitude:"+String(newLocation.coordinate.longitude)
        
        let loc = CLLocation(latitude: 38.041959, longitude:-78.503392)
        print("Loc: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
        print("Dist: \(round(newLocation.distanceFromLocation(loc)))")
        
        distance = round(newLocation.distanceFromLocation(loc))
        
        if(distance > 5000){
            Proximity.text = "You are " + String( distance) + "\n meters from the station, that's too far!"
        }
        else{
            Proximity.text = "You are only " + String( distance) + "\n meters from the station.  Tune in!!!"
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
        
        self.title = "Stream Control"
        
        streamIndicator.image = UIImage(named: "Stream Off")
        
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
        streamIndicator.image = UIImage(named: "Stream On")

    }
    
    func pauseRadio() {
        RadioStream.sharedInstance.pause()
        playButton.setTitle("Play", forState: UIControlState.Normal)
        streamIndicator.image = UIImage(named: "Stream Off")

        
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
