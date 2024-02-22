import Foundation
import UIKit
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    let mapItem: MKMapItem
    let id: UUID
    var isSelected: Bool = false
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        self.id = UUID()
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
    var name : String {
        mapItem.name ?? ""
    }
    
    var phone : String {
        mapItem.phoneNumber ?? ""
        
    }
    
    var adress : String {
        
        "\(mapItem.placemark.subThoroughfare ??  "") , \(mapItem.placemark.thoroughfare ?? "") , \(mapItem.placemark.locality ?? "") , \(mapItem.placemark.countryCode ?? "")"
    }
    
    
    
}

