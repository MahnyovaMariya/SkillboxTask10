import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    let sights: [Sight] = [Sight(coordinate: CLLocationCoordinate2D(latitude: 55.76901, longitude: 37.635476), name: "Московский академический театр им. В. Маяковского", image: UIImage(named: "MA.jpg")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.761399, longitude: 37.638886), name: "Интерактивный Бэби театр", image: UIImage(named: "BA.png")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.7644, longitude: 37.649072), name: "Московский театр Олега Табакова", image: UIImage(named: "TA.jpg")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.771876, longitude: 37.676263), name: "Московский драматический театр им. С.А.Есенина", image: UIImage(named: "EA.jpeg")!),
        Sight(coordinate: CLLocationCoordinate2D(latitude: 55.772837, longitude: 37.682051), name: "Московский театр кукол", image: UIImage(named: "DA.jpg")!)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSightRegion()
    }
    
    func setSightRegion() {
        let target = CLLocationCoordinate2D(latitude: 55.76974, longitude: 37.660016)
        let cameraPosition = GMSCameraPosition.camera(withTarget: target, zoom: 13.5)
        let mapView = GMSMapView(frame: CGRect.zero, camera: cameraPosition)
        mapView.delegate = self
        view = mapView
        
        for i in 0..<sights.count {
            let position = CLLocationCoordinate2D(latitude: sights[i].coordinate.latitude, longitude: sights[i].coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.icon = sights[i].image
            marker.map = mapView
            marker.userData = sights[i].name
        }
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let theatreName = marker.userData!
        print("********************************************************")
        print("\(theatreName)")
        return true
    }
}
