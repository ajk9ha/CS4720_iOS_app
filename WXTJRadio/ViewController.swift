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
import CoreData

extension NSOutputStream {
    
    /// Write String to outputStream
    ///
    /// - parameter string:                The string to write.
    /// - parameter encoding:              The NSStringEncoding to use when writing the string. This will default to UTF8.
    /// - parameter allowLossyConversion:  Whether to permit lossy conversion when writing the string.
    ///
    /// - returns:                         Return total number of bytes written upon success. Return -1 upon failure.
    
    func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = true) -> Int {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: allowLossyConversion) {
            var bytes = UnsafePointer<UInt8>(data.bytes)
            var bytesRemaining = data.length
            var totalBytesWritten = 0
            
            while bytesRemaining > 0 {
                let bytesWritten = self.write(bytes, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    return -1
                }
                
                bytesRemaining -= bytesWritten
                bytes += bytesWritten
                totalBytesWritten += bytesWritten
            }
            
            return totalBytesWritten
        }
        
        return -1
    }
    
}



class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, NSXMLParserDelegate, UITableViewDataSource,UITableViewDelegate  {

    //Mark: Properties
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var songText: UITextField!
    @IBOutlet weak var outputText: UILabel!
//    @IBOutlet weak var playButton: UIButton!
//    @IBOutlet weak var lat: UILabel!
//    @IBOutlet weak var Lon: UILabel!
//    @IBOutlet weak var Proximity: UILabel!
    
    @IBOutlet weak var ScrapedPlaylist: UITableView!
    var songs = [String]()
    var appDelegate: AppDelegate?
    var locationManager: CLLocationManager?
    var songInfoText = ""
    var currentParsedElement = String()
    var weAreInsideAnItem = false
     var Lyrics: String!
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        if locations.count == 0{
//            //handle error here
//            return
//        }
//        
//        let newLocation = locations[0]
//        
//        print("Latitude = \(newLocation.coordinate.latitude)")
//        print("Longitude = \(newLocation.coordinate.longitude)")
//        lat.text = "Latitude:"+String(newLocation.coordinate.latitude)
//        Lon.text = "Longitude:"+String(newLocation.coordinate.longitude)
//        
//        let loc = CLLocation(latitude: 38.041959, longitude:-78.503392)
//        if(newLocation.distanceFromLocation(loc)>5000){
//        Proximity.text = "You are \n" + String( round(newLocation.distanceFromLocation(loc))) + "\n meters from the station, that's too far!"
//        }
//        else{
//            Proximity.text = "You are only \n" + String( round(newLocation.distanceFromLocation(loc))) + "\n meters from the station.  Tune in!!!"
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager,
//        didFailWithError error: NSError){
//            print("Location manager failed with error = \(error)")
//    }
//    
//    func locationManager(manager: CLLocationManager,
//        didChangeAuthorizationStatus status: CLAuthorizationStatus){
//            
//            print("The authorization status of location services is changed to: ", terminator: "")
//            
//            switch CLLocationManager.authorizationStatus(){
//            case .AuthorizedAlways:
//                print("Authorized")
//            case .AuthorizedWhenInUse:
//                print("Authorized when in use")
//            case .Denied:
//                print("Denied")
//            case .NotDetermined:
//                print("Not determined")
//            case .Restricted:
//                print("Restricted")
//            }
//            
//    }
//    
//    func displayAlertWithTitle(title: String, message: String){
//        let controller = UIAlertController(title: title,
//            message: message,
//            preferredStyle: .Alert)
//        
//        controller.addAction(UIAlertAction(title: "OK",
//            style: .Default,
//            handler: nil))
//        
//        presentViewController(controller, animated: true, completion: nil)
//        
//    }
//    
//    func createLocationManager(startImmediately startImmediately: Bool){
//        locationManager = CLLocationManager()
//        if let manager = locationManager{
//            print("Successfully created the location manager")
//            manager.delegate = self
//            if startImmediately{
//                manager.startUpdatingLocation()
//            }
//        }
//    }
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return songs.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = songs[indexPath.row]
            
            return cell!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.songs.append(String("Hey Ya by Outkast"))
        self.songs.append(String("Hey Ya by MJ"))
        ScrapedPlaylist.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        songText.delegate = self
        artistText.delegate = self
        ScrapedPlaylist.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        do {
            let path = NSTemporaryDirectory() + "savedText.txt"
            let readString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            outputText.text = readString }
            catch let error as NSError {
            outputText.text = "No songs saved yet!"
            print(error)
        }
//        if CLLocationManager.locationServicesEnabled(){
//            
//            /* Do we have authorization to access location services? */
//            switch CLLocationManager.authorizationStatus(){
//            case .AuthorizedAlways:
//                /* Yes, always */
//                createLocationManager(startImmediately: true)
//            case .AuthorizedWhenInUse:
//                /* Yes, only when our app is in use */
//                createLocationManager(startImmediately: true)
//            case .Denied:
//                /* No */
//                displayAlertWithTitle("Not Determined",
//                    message: "Location services are not allowed for this app")
//            case .NotDetermined:
//                /* We don't know yet, we have to ask */
//                createLocationManager(startImmediately: true)
//                if let manager = self.locationManager{
//                    manager.requestAlwaysAuthorization()
//                }
//            case .Restricted:
//                /* Restrictions have been applied, we have no access
//                to location services */
//                displayAlertWithTitle("Restricted",
//                    message: "Location services are not allowed for this app")
//               locationManager?.requestAlwaysAuthorization()
//            }
//         locationManager?.requestLocation()
//    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    @IBAction func buttonPressed(sender: AnyObject) {
//        toggle()
//    
//    }
    
//    func toggle() {
//        if RadioStream.sharedInstance.currentlyPlaying() {
//            pauseRadio()
//        } else {
//            playRadio()
//        }
//    }
//    
//    func playRadio() {
//        RadioStream.sharedInstance.play()
//        playButton.setTitle("Pause", forState: UIControlState.Normal)
//    }
//    
//    func pauseRadio() {
//        RadioStream.sharedInstance.pause()
//        playButton.setTitle("Play", forState: UIControlState.Normal)
//        
//    }

    // Mark: Actions
    @IBAction func setSong(sender: UIButton) {
        songInfoText = songText.text! + " by " + artistText.text!
        outputText.text = songInfoText
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Song",
            inManagedObjectContext:managedContext)
        
        let song = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        song.setValue(songInfoText, forKey: "title")
        
        //4
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
       /* let someText = songText.text! + " by " + artistText.text!+"\n"
        let destinationPath = NSTemporaryDirectory()+"savedText.txt"
        do {
            let artist: String = artistText.text!
            let finalartist = artist.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let song: String = songText.text!
            let finalsong = song.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let urlstring = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist="+finalartist+"&song="+finalsong
            let url = NSURL(string: urlstring)
            let xmlParser = NSXMLParser(contentsOfURL: url!)
            xmlParser!.delegate = self
            xmlParser!.parse()
            
            
            
            if let outputStream = NSOutputStream(toFileAtPath: destinationPath, append: true) {
                outputStream.open()
                outputStream.write(self.Lyrics)
                
                outputStream.close()
            }
        } catch let error as NSError {
            print("An error occurred: \(error)") }
*/
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("HERE")
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Song",
            inManagedObjectContext:managedContext)
        
        let song = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        song.setValue(songs[indexPath.row], forKey: "title")
        
        //4
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func displayLyrics(segue: AnyObject) {
    }
        
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "LyricSegue") {
            
            let lyricsView = segue.destinationViewController as! LyricsViewController
            lyricsView.artistText = artistText.text!
            lyricsView.songText = songText.text!
        
        } else {
            songInfoText = songText.text! + " by " + artistText.text!
        
            print(segue.identifier)
        
            let favoritesView = segue.destinationViewController as! FavoriteSongsViewController
        
            favoritesView.playlistText = songInfoText
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == songText) {
            artistText.becomeFirstResponder()
        }
        
        return true
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
     override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            RadioStream.sharedInstance.toggle()
        }
    }
     func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String:String] ){
        switch elementName {
        case "Lyric":
            Lyrics = String()
            currentParsedElement = elementName
        default:break
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
            if( currentParsedElement=="Lyric"){
                Lyrics = Lyrics + string
                print(Lyrics)
            
            }
        }
   


}

