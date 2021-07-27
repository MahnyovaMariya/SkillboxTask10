import Foundation
import YandexMapsMobile

class YandexSight {
    var name: String
    var coordinate: YMKPoint
    var image: UIImage
    init(name: String, coordinate: YMKPoint, image: UIImage) {
        self.name = name
        self.coordinate = coordinate
        self.image = image
    }
}
