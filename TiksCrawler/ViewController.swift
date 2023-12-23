//
//  ViewController.swift
//  TiksCrawler
//
//  Created by Dương Nguyễn on 20/12/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let parser = HTMLParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let link = "https://www.tiktok.com/@the_coaster_scoop/video/7290942038466465067?is_from_webapp=1&sender_device=pc"
        self.parser.getInfo(link: link)
    }
}

