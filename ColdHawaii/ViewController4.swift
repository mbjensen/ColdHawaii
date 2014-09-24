//
//  ViewController4.swift
//  ColdHawaii
//
//  Created by Morten Brodersen Jensen on 22/09/14.
//  Copyright (c) 2014 Morten Brodersen Jensen. All rights reserved.
//

import UIKit

class ViewController4: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let tableText = ["Restaurant", "Pizza", "Café"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell") as? UITableViewCell
        var thumbnail:Array = ["map", "phone", "internet"]
        
        //Sets the cell style, accessory type and text lable
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "myCell")
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell!.textLabel?.text = tableText[indexPath.row]
        cell!.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.imageView?.image = UIImage(named: thumbnail[indexPath.row])
        cell?.accessoryView = UIImageView(image: UIImage(named:"forward"))
        
        //Shows the phone number at the cell
        if (indexPath.item == 1) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "myCell")
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.textLabel?.text = tableText[indexPath.row]
            cell!.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.accessoryView = UIImageView(image: UIImage(named:"forward"))
            cell?.imageView?.image = UIImage(named: thumbnail[indexPath.row])
            //cell!.detailTextLabel?.text = phoneNumber
            cell!.detailTextLabel?.textColor = UIColor.whiteColor()
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let viewController = self.navigationController?.viewControllers.first as ViewController
        //Makes the action based on the cell the user is pressing in the tableview
        switch indexPath.item {
            
        case 0:
            buttomClicked = "Restaurant"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 1:
            buttomClicked = "Pizza"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
            self.navigationController?.popToRootViewControllerAnimated(true)
        case 2:
            buttomClicked = "Café"
            viewController.hiddenTravelingTime()
            viewController.updateAnnotationView()
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
