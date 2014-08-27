import UIKit
import MapKit
import CoreLocation

var buttomClicked:String = "Home"

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
                            
    @IBOutlet var theMapView: MKMapView!
    
    var annotations:NSMutableArray?
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    //When Home buttom clicked updates Annotations on map through viewDidLoad
    @IBAction func btnHome_Clicked() {
        
        buttomClicked = "Home"
        updateAnnotationView()
    }
    
    //When Surf buttom clicked updates Annotations on map through viewDidLoad
    @IBAction func btnSurf_Clicked() {
        
        buttomClicked = "Surf"
        updateAnnotationView()
    }
    
    //When Food buttom clicked updates Annotations on map through viewDidLoad
    @IBAction func btnFood_Clicked() {
        
        buttomClicked = "Food"
        updateAnnotationView()
    }
    
    @IBAction func btnMe_Clicked() {
        
        //Show the users location on the map
        self.theMapView!.showsUserLocation = true
        self.theMapView!.delegate = self
        self.theMapView!.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
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
    
    //Reads the plist for annotations once and initilise the array annotations with data
    func callCreateAnnotationsOnce() {
        annotations = createAnnotations()
    }
    
    //Updates the view based on the buttom pressed
    func updateAnnotationView() {
        
        for annotation:AnyObject in annotations! {
            if let annotation = annotation as? CustomAnnotation {
                if (annotation.key == buttomClicked) {
                    
                    //Call the func mapViewAnnotation given theMapView and annotation as parametre. Returns a MKAnnotationView
                    var mapViewAnnotations:MKAnnotationView = self.mapView(theMapView!, viewForAnnotation: annotation)
                    
                    self.theMapView!.addAnnotation(mapViewAnnotations.annotation)
                    //Displayes the title and subtitle of the annotation per default
                    self.theMapView!.selectAnnotation(mapViewAnnotations.annotation, animated: true)
                } else {
                    self.theMapView!.removeAnnotation(annotation)
                }
            }
        }
        self.theMapView!.setRegion(zoomToLocation(), animated: true)
    }
    
    func btnRoute_Clicked() {
        
        var directionsRequest:MKDirectionsRequest = MKDirectionsRequest()
        var placemark:MKPlacemark = MKPlacemark()
        
        //directionsRequest.setDestination
        
        self.theMapView!.userLocation.location
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
            println(imageTitle)
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
        //println(view.annotation.title)
    }
    
    
    
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
        self.theMapView!.mapType = MKMapType.Satellite
        
        //Creates all the annotations once
        callCreateAnnotationsOnce()
        
        //Sets the annotaion of Pinbak24
        updateAnnotationView()
        //Sets the region to Klitmoeller
        buttomClicked = "Klitmoeller"
        self.theMapView!.setRegion(zoomToLocation(), animated: true)
    }
    
    func convertAnnotationTitleToImageName(titleString:String) -> String {
        var imageString = titleString.lowercaseString
        
        imageString = imageString.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
 
        return imageString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

