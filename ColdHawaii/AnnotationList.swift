//
//  AnnotationList.swift
//  ColdHawaii
//
//  Created by Morten Brodersen Jensen on 28/08/14.
//  Copyright (c) 2014 Morten Brodersen Jensen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let sharedInstanceAnnotationList = AnnotationList()

class AnnotationList {
    
    //Creates a array of CustomAnnotations objects. Gets the data from the plist
    func createAnnotations() -> NSMutableArray {
        
        let path = NSBundle.mainBundle().pathForResource("locations", ofType: "plist")
        var locations = NSArray(contentsOfFile: path!)
        
        var annotations:NSMutableArray = []
        
        if (locations.count > 0) {
            for location:AnyObject in locations {
                var latitude:CLLocationDegrees = location.objectForKey("latitude") as CLLocationDegrees
                var longitude:CLLocationDegrees = location.objectForKey("longitude") as CLLocationDegrees
                
                var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                
                var currentTitle = location.objectForKey("title") as String
                var currentSubtitle = location.objectForKey("subtitle") as String
                var currentKey = location.objectForKey("key") as String
                
                var annotation:CustomAnnotation = CustomAnnotation(coordinate: currentLocation, title: currentTitle, subtitle: currentSubtitle, key: currentKey)
                
                annotations.addObject(annotation)
            }
        }
        return annotations
    }
    
    func getUrl(location:String) -> String {
        
        let path = NSBundle.mainBundle().pathForResource("locations", ofType: "plist")
        var plist = NSArray(contentsOfFile: path!)
        var url:String = ""
        
        if (plist.count > 0) {
            for urlString:AnyObject in plist {
                if (urlString.containsObject(location)) {
                    url = urlString.objectForKey("url") as String
                }
            }
        }
        return url
    }
    
    func getPhoneNumber(location:String) -> String {
        
        let path = NSBundle.mainBundle().pathForResource("locations", ofType: "plist")
        var plist = NSArray(contentsOfFile: path!)
        var phoneNumber:String = ""
        
        if (plist.count > 0) {
            for number:AnyObject in plist {
                if (number.containsObject(location)) {
                    phoneNumber = number.objectForKey("phone") as String
                }
            }
        }
        return phoneNumber
    }
    
    //Set the region at the map. Reads the plist and returns theRegion of the last place in the list
    func zoomToLocation() -> MKCoordinateRegion {
        
        var theRegion:MKCoordinateRegion!
        
        let path = NSBundle.mainBundle().pathForResource("regions", ofType: "plist")
        var locations = NSArray(contentsOfFile: path!)
        
        if (locations.count > 0) {
            for location:AnyObject in locations {
                if (location.containsObject(buttomClicked)) {
                    var latitude:CLLocationDegrees = location.objectForKey("latitude") as CLLocationDegrees
                    var longitude:CLLocationDegrees = location.objectForKey("longitude") as CLLocationDegrees
                    
                    var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    var latDelta:CLLocationDegrees = location.objectForKey("latDelta") as CLLocationDegrees
                    var longDelta:CLLocationDegrees = location.objectForKey("longDelta") as CLLocationDegrees
                    
                    var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                    
                    theRegion = MKCoordinateRegionMake(currentLocation, theSpan)
                }
            }
        }
        return theRegion
    }
}

