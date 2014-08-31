import UIKit
import MapKit
import CoreLocation

var buttomClicked:String = "Home"

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
                            
    @IBOutlet var theMapView: MKMapView!
    
    var annotationsList:NSMutableArray = sharedInstanceAnnotationList.createAnnotations()
    var locationManager:CLLocationManager = CLLocationManager()
    var locationString:String = "Location"
    var imageViewString:String = "pinbak24"
    
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
    
    //Updates the view based on the buttom pressed
    func updateAnnotationView() {
        
        for annotation:AnyObject in annotationsList {
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
        self.theMapView!.setRegion(sharedInstanceAnnotationList.zoomToLocation(), animated: true)
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
 
        //Sets the annotaion of Pinbak24
        updateAnnotationView()
        //Sets the region to Klitmoeller
        buttomClicked = "Klitmoeller"
        self.theMapView!.setRegion(sharedInstanceAnnotationList.zoomToLocation(), animated: true)
    }
    
    func convertAnnotationTitleToImageName(titleString:String) -> String {
        var imageString = titleString.lowercaseString
        imageString = imageString.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
 
        return imageString
    }
    
    //Calls the Segue (The next scene) with the identifier "Show Info" and sends the annotationView with
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            //Sets the label for location in Viewcontroller2
            locationString = annotationView.annotation.title!
            self.performSegueWithIdentifier("Show Info", sender: self)
            println(annotationView.annotation.title!)
        }
    }
    
    //Gets called before the Segue is preformed. Used to send data to the next view
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Show Info" {
            let vc = segue.destinationViewController as ViewController2
            vc.locationString = locationString
            vc.imageViewTitle = convertAnnotationTitleToImageName(locationString)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

