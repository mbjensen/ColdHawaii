//
//  ViewController2.swift
//  ColdHawaii
//
//  Created by Morten Brodersen Jensen on 28/08/14.
//  Copyright (c) 2014 Morten Brodersen Jensen. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var locationLabel:UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    let tableText = ["Directions", "Phone", "More info"]
    var locationString:String = "Location"
    var imageViewTitle:String = "pinbak24"
    var phoneNumber:String = "00000000"
    
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
            cell!.detailTextLabel?.text = phoneNumber
            cell!.detailTextLabel?.textColor = UIColor.whiteColor()
            
            if (showPhoneNumber == false) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")
                cell!.backgroundColor = UIColor.clearColor()
                cell?.textLabel?.textColor = UIColor.whiteColor()
                cell!.textLabel?.text = "Se route at \"More info\""
                cell?.imageView?.image = UIImage(named: "route")
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background"))
        locationLabel.text = locationString
        var image = UIImage(named: imageViewTitle + "_stor")
        imageView.image = image
        phoneNumber = sharedInstanceAnnotationList.getPhoneNumber(locationString)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let index = tableView.indexPathForSelectedRow()

        if segue.identifier == "Web" {
            let vc = segue.destinationViewController as ViewController3
            vc.locationString = locationString
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var removeMe:String = ""
        //Makes the action based on the cell the user is pressing in the tableview
        switch indexPath.item {
            
            //Show the direction for the location
            case 0:
            //Class functions in ViewController
            let viewController = self.navigationController?.viewControllers.first as ViewController
            viewController.removeOverlay()
            viewController.createDirection()
            viewController.visableTravelingTime()
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            //Show the phone number for the location
            case 1:
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phoneNumber))
            
            //Show the web page for the location
            case 2:
                self.performSegueWithIdentifier("Web", sender: self)
            
            default:
                removeMe = ""
        }
    }
}
