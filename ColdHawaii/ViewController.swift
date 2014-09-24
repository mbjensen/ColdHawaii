import UIKit
import MapKit
import CoreLocation

var buttomClicked:String = "Home"
let SEC_MIN:Int = 60
let SEC_HOUR:Int = 3600
let SEC_DAY:Int = 86400

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
                            
    @IBOutlet var theMapView: MKMapView!
    @IBOutlet weak var transportTypeControl: UISegmentedControl!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var timeOutput: UITextField!
    
    var annotationsList:NSMutableArray = sharedInstanceAnnotationList.createAnnotations()
    var locationManager:CLLocationManager = CLLocationManager()
    var locationString:String = "Pinbak 24"
    var imageViewString:String = "pinbak24"
    var routeDetails:MKRoute = MKRoute()
    var transportType:MKDirectionsTransportType = MKDirectionsTransportType.Walking
    var travelingTime:NSTimeInterval = NSTimeInterval()
    
    //Creates the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keeps track of the user location. Ask for permission to current location
        locationManager.delegate = self
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Sets map to hybrid
        self.theMapView!.mapType = MKMapType.Hybrid
        
        //Sets the annotaion of Pinbak24
        updateAnnotationView()
        //Sets the region to Klitmoeller
        buttomClicked = "Klitmoeller"
        self.theMapView!.setRegion(sharedInstanceAnnotationList.zoomToLocation(), animated: true)
    }
    
    func tabBar(tabBar: UITabBar!, didSelectItem item: UITabBarItem!) {
        
        switch item.tag  {
        //When Home buttom clicked updates Annotations on map through viewDidLoad
        case 0:
            buttomClicked = "Home"
            hiddenTravelingTime()
            updateAnnotationView()
            break
        //When Surf buttom clicked updates Annotations on map through viewDidLoad
        case 1:
            buttomClicked = "Surf"
            hiddenTravelingTime()
            updateAnnotationView()
            break
        //When Food buttom clicked updates Annotations on map through viewDidLoad
        case 2:
            buttomClicked = "Food"
            hiddenTravelingTime()
            updateAnnotationView()
            break
        case 3:
            //Show the users location on the map
            self.theMapView!.showsUserLocation = true
            self.theMapView!.delegate = self
            self.theMapView!.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
            hiddenTravelingTime()
            break
        case 4:
            self.performSegueWithIdentifier("More", sender: self)
            break
        default:
            buttomClicked = "Home"
            break
        }
    }
    
    func visableTravelingTime() {
        timeOutput.hidden = false
        transportTypeControl.hidden = false
    }
    
    func hiddenTravelingTime() {
        timeOutput.hidden = true
        transportTypeControl.hidden = true
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch transportTypeControl.selectedSegmentIndex {
            
        case 0:
            transportType = MKDirectionsTransportType.Walking
            removeOverlay()
            createDirection()
            travelingTime = routeDetails.expectedTravelTime
            timeOutput.text = displayTravelingTime()
        case 1:
            transportType = MKDirectionsTransportType.Automobile
            removeOverlay()
            createDirection()
            travelingTime = routeDetails.expectedTravelTime
            timeOutput.text = displayTravelingTime()
        default:
            break;
        }
    }
    
    //Updates the view based on the buttom pressed
    func updateAnnotationView() {
        
        var annotationInTheView:NSMutableArray = NSMutableArray()
        
        for annotation:AnyObject in annotationsList {
            if let annotation = annotation as? CustomAnnotation {
                if (annotation.key == buttomClicked) {
                    
                    //Call the func mapViewAnnotation given theMapView and annotation as parametre. Returns a MKAnnotationView
                    var mapViewAnnotations:MKAnnotationView = self.mapView(theMapView!, viewForAnnotation: annotation)
                    self.theMapView!.addAnnotation(mapViewAnnotations.annotation)
                    //Makes a array of annotations in the current view
                    annotationInTheView.addObject(mapViewAnnotations.annotation)
                    //Displayes the title and subtitle of the annotation per default
                    self.theMapView!.selectAnnotation(mapViewAnnotations.annotation, animated: true)
                } else {
                    self.theMapView!.removeAnnotation(annotation)
                }
            }
        }
        
        //Removes the route drawed on the map
        removeOverlay()
        //Sets the zoom on the map
        self.theMapView!.showAnnotations(annotationInTheView, animated: true)
        //self.theMapView!.setRegion(sharedInstanceAnnotationList.zoomToLocation(), animated: true)
    }
    
    func removeOverlay() {
        self.theMapView.removeOverlay(self.routeDetails.polyline)
    }

    //Gets route from apple server and draw it on the map
    func createDirection() {
        
        //Gets all the location data to make a request.
        var directionsRequest:MKDirectionsRequest = MKDirectionsRequest()
        var destinationPlacemark:MKPlacemark = sharedInstanceAnnotationList.getDestinationLocation(locationString)
        var userLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude)
        var userLocationPlacemark:MKPlacemark = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        var user:MKMapItem = MKMapItem(placemark: userLocationPlacemark)
        var destination:MKMapItem = MKMapItem(placemark: destinationPlacemark)
        
        //Sets the zoom level to display the hole route in the view
        var annotationPointUser:MKMapPoint = MKMapPointForCoordinate(theMapView.userLocation.coordinate)
        var pointRectUser:MKMapRect = myMKMapRect(annotationPointUser.x, y: annotationPointUser.y, w: 0.2, h: 0.2)
        var annotationPointDestination:MKMapPoint = MKMapPointForCoordinate(destinationPlacemark.coordinate)
        var pointRectDestination:MKMapRect = myMKMapRect(annotationPointDestination.x, y: annotationPointDestination.y, w: 0.2, h: 0.2)
        var zoomRect = MKMapRectUnion(pointRectUser, pointRectDestination)
        
        //Sets the current location and final destanation plus transport type
        directionsRequest.setSource(user)
        directionsRequest.setDestination(destination)
        directionsRequest.requestsAlternateRoutes = true
        directionsRequest.transportType = transportType
        
        var directions:MKDirections = MKDirections(request: directionsRequest)
        
        //Makes the request to the apple server and handles if nil else the route is drawed on the map
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in

            if error != nil {
                println("Error")
            }
            if response != nil {
                self.routeDetails = response.routes.first as MKRoute
                self.theMapView.addOverlay(self.routeDetails.polyline)
                self.travelingTime = self.routeDetails.expectedTravelTime
                self.timeOutput.text = self.displayTravelingTime()
            }
            else {
                println("No response")
            }
        })
        
        self.theMapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100) , animated: true)
        //self.theMapView.setVisibleMapRect(zoomRect, animated: true)
    }
    
    func myMKMapRect(x: Double, y:Double, w:Double, h:Double) -> MKMapRect {
        return MKMapRect(origin:MKMapPoint(x:x, y:y), size:MKMapSize(width:w, height:h))
    }
    
    //Ovverrides the default annotation and set specified properties. Sets the left and right callout in the annotation
    func mapView(mapView:MKMapView, viewForAnnotation annotation:MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        //if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        pinView!.pinColor = .Red
        pinView!.canShowCallout = true
        
        //Set the right images for the left side of the annotation by the title
        var imageTitle = convertAnnotationTitleToImageName(annotation.title!)
        var image = UIImage(named:imageTitle)
        var imageView:UIImageView = UIImageView(image: image)
       
        pinView!.leftCalloutAccessoryView = imageView
            
        var disclosureButton = UIButton()
        disclosureButton.setBackgroundImage(UIImage(named:"disclosure"), forState: UIControlState.Normal)
        disclosureButton.sizeToFit()
        pinView!.rightCalloutAccessoryView = disclosureButton
            
        pinView!.annotation = annotation
            
        self.mapView(theMapView!, didSelectAnnotationView: pinView!)
        //} else {
            //pinView!.annotation = annotation
        //}
        
        return pinView
    }
    
    //When the user selecs a specified annotationen the function prints the annotations title to the console
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var routeLineRenderer:MKPolylineRenderer = MKPolylineRenderer(polyline: routeDetails.polyline)
        routeLineRenderer.strokeColor = UIColor(hue: 0.6, saturation: 0.6, brightness: 0.6, alpha: 0.6)
        routeLineRenderer.lineWidth = 5
        
        return routeLineRenderer
    }
    
    func convertAnnotationTitleToImageName(titleString:String) -> String {
        var imageString = titleString.lowercaseString
        imageString = imageString.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
 
        return imageString
    }
    
    //Calls the Segue (The next scene) with the identifier "Show Info" and sends the annotationView with
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //Sets the color of pressed pins to green
        var annotation:MKPinAnnotationView = annotationView as MKPinAnnotationView
        if (annotation.pinColor == .Red) {
            annotation.pinColor = .Green
        } else if (locationString == annotationView.annotation.title!) {
            annotation.pinColor = .Green
            self.theMapView.annotationVisibleRect
        } else {
            annotation.pinColor = .Red
        }
    
        if control == annotationView.rightCalloutAccessoryView {
            //Sets the label for location in Viewcontroller2
            locationString = annotationView.annotation.title!
            self.performSegueWithIdentifier("Show Info", sender: self)
        }
    }
    
    //Gets called before the Segue is preformed. Used to send data to the next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "Show Info" {
            let vc = segue.destinationViewController as ViewController2
            vc.locationString = locationString
            vc.imageViewTitle = convertAnnotationTitleToImageName(locationString)
        }
    }
    
    func displayTravelingTime() -> String {
        
        var minutes = Int(travelingTime) / SEC_MIN
        var hours = Int(travelingTime) / SEC_HOUR
        var days = Int(travelingTime) / SEC_DAY
        
        var travelingTimeString:String = "\(minutes) min"
        
        if (minutes > 59) {
            var rest = Int(travelingTime) % SEC_HOUR
            minutes = rest / SEC_MIN
            if (minutes == 0) {
                travelingTimeString = "\(hours) t"
            } else {
                travelingTimeString = "\(hours) t \(minutes) min"
            }
        }
        if (hours > 23) {
            var rest = Int(travelingTime) % SEC_DAY
            hours = rest / SEC_HOUR
            if (hours == 0) {
                travelingTimeString = "\(days) d"
            } else {
                travelingTimeString = "\(days) d \(hours) t"
            }
        }

        return travelingTimeString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

