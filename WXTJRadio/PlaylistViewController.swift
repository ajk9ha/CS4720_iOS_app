//
//  PlaylistViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 11/4/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var playlistView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playlistUrl = NSURL(string: "http://www.wtju.net/player/?station=wtjx")
        let request = NSURLRequest(URL: playlistUrl!)
        
        playlistView.loadRequest(request)

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
