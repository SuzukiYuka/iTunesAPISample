//
//  DetailViewController.swift
//  iTunesAPISample
//
//  Created by nagata on 6/5/15.
//  Copyright (c) 2015 nagata. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DetailViewController: AVPlayerViewController {
    var trackName: String!
    var previewUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = trackName
        
        if let previewUrl = previewUrl {
            player = AVPlayer(URL: NSURL(string: previewUrl))
            player.play()
        }
    }
}
