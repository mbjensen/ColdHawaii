//
//  ViewController4.swift
//  ColdHawaii
//
//  Created by Morten Brodersen Jensen on 22/09/14.
//  Copyright (c) 2014 Morten Brodersen Jensen. All rights reserved.
//

import UIKit

var showPhoneNumber:Bool = true

class ViewController4: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let tableText = ["Restaurant", "Pizza", "Café", "Bicycle Rental", "Running Routes", "MTB Routes", "Hiking Routes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell") as? UITableViewCell
        var thumbnail:Array = ["map", "phone", "internet", "", "", "", ""]
        
        //Sets the cell style, accessory type and text lable
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "myCell")
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell!.textLabel?.text = tableText[indexPath.row]
        cell!.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.imageView?.image = UIImage(named: thumbnail[indexPath.row])
        cell?.accessoryView = UIImageView(image: UIImage(named:"forward"))
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableText.count
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let viewController = self.navigationController?.viewControllers.first as ViewController
        //Makes the action based on the cell the user is pressing in the tableview
        switch indexPath.item {
            
        case 0:
            buttomClicked = "Restaurant"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            showPhoneNumber = true
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 1:
            buttomClicked = "Pizza"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            showPhoneNumber = true
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 2:
            buttomClicked = "Café"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            showPhoneNumber = true
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 3:
            buttomClicked = "Bicycle"
            viewController.hiddenTravelingTime()
            showPhoneNumber = true
            viewController.updateAnnotationView()
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 4:
            buttomClicked = "Running"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            showPhoneNumber = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 5:
            buttomClicked = "MTB"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            showPhoneNumber = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 6:
            buttomClicked = "Hiking"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            showPhoneNumber = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
