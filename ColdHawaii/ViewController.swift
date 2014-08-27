import UIKit
import MapKit
import CoreLocation

var buttomClicked:String = "Klitmoeller"

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
                            
    @IBOutlet var theMapView: MKMapView?
    
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
                }else {
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
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.pinColor = .Green
            
            pinView!.canShowCallout = true
            
            var imageView:UIImageView = UIImageView(frame:CGRectMake(0, 0 ,46, 46))
            pinView!.leftCalloutAccessoryView = imageView
            
            var disclosureButton = UIButton()
            disclosureButton.setBackgroundImage(UIImage(named:"disclosure"), forState: UIControlState.Normal)
            disclosureButton.sizeToFit()
            pinView!.rightCalloutAccessoryView = disclosureButton
            
            pinView!.annotation = annotation
            
            updateLeftCalloutAccessoryViewInAnnotationView(pinView!)
            
            self.mapView(theMapView!, didSelectAnnotationView: pinView!)
        }
        return pinView
    }
    
    //When the user selecs a specified annotationen the function prints the annotations title to the console
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        println(view.annotation.title)
    }
    
    func updateLeftCalloutAccessoryViewInAnnotationView(annotationView:MKAnnotationView) {
        
        var imageView:UIImageView = UIImageView()
        if (annotationView.leftCalloutAccessoryView.isKindOfClass(UIImageView)) {
            imageView = annotationView.leftCalloutAccessoryView as UIImageView
        }
        
        imageView.image = UIImage(named:"test")
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
        theMapView!.mapType = MKMapType.Hybrid
        
        self.theMapView!.setRegion(zoomToLocation(), animated: true)
        
        callCreateAnnotationsOnce()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

