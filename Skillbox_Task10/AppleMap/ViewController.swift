import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func plusButtonClick(_ sender: Any) {

        let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 2, longitudeDelta: mapView.region.span.longitudeDelta / 2)
        let region = MKCoordinateRegion(center: mapView.region.center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
   
        let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta * 2, longitudeDelta: mapView.region.span.longitudeDelta * 2)
        let region = MKCoordinateRegion(center: mapView.region.center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func userLocationButtonClick(_ sender: Any) {
        
        setUserRegion(userLocationAMLatitude: userLocationAMLatitude, userLocationAMLongitude: userLocationAMLongitude)
        
    }
    
    let sightsCoordinates: [Sight] = [Sight(coordinate: CLLocationCoordinate2D(latitude: 55.76901, longitude: 37.635476), name: "Московский академический театр им. В. Маяковского", image: UIImage(named: "MA.jpg")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.761399, longitude: 37.638886), name: "Интерактивный Бэби театр", image: UIImage(named: "BA.png")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.7644, longitude: 37.649072), name: "Московский театр Олега Табакова", image: UIImage(named: "TA.jpg")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.771876, longitude: 37.676263), name: "Московский драматический театр им. С.А.Есенина", image: UIImage(named: "EA.jpeg")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.772837, longitude: 37.682051), name: "Московский театр кукол", image: UIImage(named: "DA.jpg")!)]
    
    let locationManager = CLLocationManager()
    var userLocationAMLatitude = 0.0
    var userLocationAMLongitude = 0.0
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        mapView.delegate = self
        setLocation()
        setSightRegion()
    }
    
    func setLocation() {
        
        
        locationManager.requestAlwaysAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
//        }
        
    }
    
    func setSightRegion() {
        
        let center = CLLocationCoordinate2D(latitude: 55.76974, longitude: 37.660016)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    
        self.placeSights()
    }
    
    func setUserRegion(userLocationAMLatitude: Double, userLocationAMLongitude: Double) {
        
        let center = CLLocationCoordinate2D(latitude: userLocationAMLatitude, longitude: userLocationAMLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func placeSights() {

        for elem in sightsCoordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = elem.coordinate
            annotation.title = elem.name
            mapView.addAnnotation(annotation)
        }
    }
}

extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        
        for i in 0..<sightsCoordinates.count {
            if annotation.title == sightsCoordinates[i].name {
                annotationView.image = sightsCoordinates[i].image
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let theatreName = view.annotation?.title ?? "Театр не найден"
        print("********************************************************")
        print(theatreName!)
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        userLocationAMLatitude = location.latitude
        userLocationAMLongitude = location.longitude
//        print("\(location.latitude) \(location.longitude)pppp")
    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        manager.stopUpdatingLocation()
//    }
}

