//
//  FavoriteSongsViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 10/18/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit

class FavoriteSongsViewController: UIViewController {
    
    @IBOutlet weak var playlistEntry: UILabel!
    @IBOutlet weak var playlist: UITextView!
    var playlistText = "Initial Value"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        playlistEntry.text = playlistText
        playlist.text.appendContentsOf(playlistText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
