//
//  ViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 10/16/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //Mark: Properties
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var songText: UITextField!
    @IBOutlet weak var outputText: UILabel!
    var songInfoText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        songText.delegate = self;
        artistText.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        favoritesView.playlist.text = songInfoText
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == songText) {
            artistText.becomeFirstResponder()
        }
        
        return true
    }



}

