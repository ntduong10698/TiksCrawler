//
//  ViewController.swift
//  TiksCrawler
//
//  Created by Dương Nguyễn on 20/12/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let parser = HTMLParser()
    private let googleImages = GoogleImages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.googleImages.search(query: "a", start: 10)
    }
}

