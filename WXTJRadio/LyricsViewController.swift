//
//  LyricsViewController.swift
//  WXTJRadio
//
//  Created by Andrew Kovalenko on 11/23/15.
//  Copyright © 2015 University of Virginia. All rights reserved.
//

import UIKit

class LyricsViewController: UIViewController, NSXMLParserDelegate {
    
    @IBOutlet weak var lyricsText: UITextView!
    @IBOutlet weak var songInfo: UILabel!
    
    var weAreInsideAnItem = false
    var Lyrics: String!
    var currentParsedElement = String()
    var artistText = ""
    var songText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let artist: String = artistText.text!
        let finalartist = artistText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        let song: String = songText.text!
        let finalsong = songText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let urlstring = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist="+finalartist+"&song="+finalsong
        let url = NSURL(string: urlstring)
        let xmlParser = NSXMLParser(contentsOfURL: url!)
        xmlParser!.delegate = self
        xmlParser!.parse()
       
        if(Lyrics != "") {
            lyricsText.text = Lyrics
        } else {
            lyricsText.text = "Could not find song"
        }
        lyricsText.text = Lyrics
        
        songInfo.text = songText + " by " + artistText
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
