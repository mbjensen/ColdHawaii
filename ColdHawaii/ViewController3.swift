//
//  ViewController3.swift
//  ColdHawaii
//
//  Created by Morten Brodersen Jensen on 30/08/14.
//  Copyright (c) 2014 Morten Brodersen Jensen. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var locationString = "Pinbak 24"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gets the url for the location
        var urlPath = sharedInstanceAnnotationList.getUrl(locationString)
        println(urlPath)
        loadUrlAddress(urlPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUrlAddress(urlPath:String) {
        let requestUrl = NSURL(string: urlPath)
        let request = NSURLRequest(URL: requestUrl)
        webView.loadRequest(request)
    }
}
