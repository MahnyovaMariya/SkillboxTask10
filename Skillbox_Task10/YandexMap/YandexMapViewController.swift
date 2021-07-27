import UIKit
import YandexMapsMobile

class YandexMapViewController: UIViewController {
    
    @IBOutlet weak var yandexMapView: YMKMapView!
    
    @IBAction func plusButtonClick(_ sender: Any) {

        zoom += 1.0
        yandexMapView.mapWindow.map.move(with: YMKCameraPosition(target: yandexMapView.mapWindow.map.cameraPosition.target, zoom: Float(zoom), azimuth: 0, tilt: 0), animationType: YMKAnimation(type: .smooth, duration: 0.1), cameraCallback: nil)

    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        
        let cameraPosition = YMKCameraPosition(target: yandexMapView.mapWindow.map.cameraPosition.target, zoom: Float(zoom), azimuth: 0, tilt: 0)
        if zoom != 0.0 {
            zoom -= 1
            yandexMapView.mapWindow.map.move(with: cameraPosition, animationType: YMKAnimation(type: .smooth, duration: 0.1), cameraCallback: nil)
            print("\(cameraPosition.zoom)!!!!")
        }
        
        
        
        
    }
    
    @IBOutlet weak var userLocationButton: UIButton!
    
    @IBAction func userLocationButtonClick(_ sender: Any) {
       
        if count == 0 {
            count += 1
            setLocation()
        } else if count > 0 {
            yandexMapView.mapWindow.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: userLocationLatitude, longitude: userLocationLongitude), zoom: 14, azimuth: 0, tilt: 0))
        }
    }
    
    let points: [YandexSight] = [YandexSight(name: "Московский академический театр им. В. Маяковского", coordinate: YMKPoint(latitude: 55.76901, longitude: 37.635476), image: UIImage(named: "M.jpg")!),
        YandexSight(name: "Интерактивный Бэби театр", coordinate: YMKPoint(latitude: 55.761399, longitude: 37.638886), image: UIImage(named: "B.png")!),
        YandexSight(name: "Московский театр Олега Табакова", coordinate: YMKPoint(latitude: 55.7644, longitude: 37.649072), image: UIImage(named: "T.jpg")!),
        YandexSight(name: "Московский драматический театр им. С.А.Есенина", coordinate: YMKPoint(latitude: 55.771876, longitude: 37.676263), image: UIImage(named: "E.jpeg")!),
        YandexSight(name: "Московский театр кукол", coordinate: YMKPoint(latitude: 55.772837, longitude: 37.682051), image: UIImage(named: "D.jpg")!)]
    var placemarksArray: [YMKPlacemarkMapObject] = []
    var zoom = 14.0
    var count = 0
    var userLocationLatitude = 0.0
    var userLocationLongitude = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        yandexMapView.mapWindow.map.isZoomGesturesEnabled = false

        setSightLocation()
        createMapPoints()
    }
    
    func setLocation() {
        
        yandexMapView.mapWindow.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: 0, longitude: 0), zoom: 14, azimuth: 0, tilt: 0))
        let scale = UIScreen.main.scale
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: yandexMapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setAnchorWithAnchorNormal(CGPoint(x: 0.5 * yandexMapView.frame.size.width * scale, y: 0.5 * yandexMapView.frame.size.height * scale), anchorCourse: CGPoint(x: 0.5 * yandexMapView.frame.size.width * scale, y: 0.83 * yandexMapView.frame.size.height * scale))
        userLocationLayer.setObjectListenerWith(self)
        yandexMapView.mapWindow.map.addCameraListener(with: self)
    }
    
    
    func setSightLocation() {
        let cameraPosition = YMKCameraPosition(
            target: YMKPoint(latitude: 55.76974, longitude: 37.660016), zoom: 13.5, azimuth: 0, tilt: 0)
        yandexMapView.mapWindow.map.move(with: cameraPosition)
    }
    
    func createMapPoints() {
        
        let mapObjects = yandexMapView.mapWindow.map.mapObjects
        var placemark = mapObjects.addEmptyPlacemark(with: YMKPoint(latitude: 0.0, longitude: 0.0))
        
        for i in 0..<points.count {
            placemark = mapObjects.addPlacemark(with: points[i].coordinate, image: points[i].image)
            placemark.addTapListener(with: self)
        }
    }
}

extension YandexMapViewController: YMKUserLocationObjectListener, YMKMapObjectTapListener, YMKMapCameraListener {
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
            if userLocationLatitude == 0.0 && userLocationLongitude == 0.0 {
                userLocationLatitude = cameraPosition.target.latitude
                userLocationLongitude = cameraPosition.target.longitude
            }
    }
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return true }
        
        for i in 0..<points.count {
            if placemark.geometry.latitude == points[i].coordinate.latitude && placemark.geometry.longitude == points[i].coordinate.longitude {
                print("********************************************************")
                print(points[i].name)
            }
        }
        return true
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {}
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}
