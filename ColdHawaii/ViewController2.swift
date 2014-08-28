//
//  ViewController2.swift
//  ColdHawaii
//
//  Created by Morten Brodersen Jensen on 28/08/14.
//  Copyright (c) 2014 Morten Brodersen Jensen. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBAction func toMapPressed(sender: AnyObject) {
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
