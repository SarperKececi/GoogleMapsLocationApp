import Foundation
import UIKit
import MapKit
import CoreLocation

class PlacesViewController: UITableViewController {

    let userLocation: CLLocation
    let places: [PlaceAnnotation]

    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = place.name

        if let distanceString = formattedDistance(from: userLocation, to: place.coordinate) {
            content.secondaryText = "\(distanceString) , \(place.name) , \(place.adress)"
        }

        cell.contentConfiguration = content

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPlace = places[indexPath.row]
        let detailVC =  DetailViewController(places: selectedPlace)
        present(detailVC , animated: true)
    }
   

    // Uzaklık hesaplama fonksiyonu
    func formattedDistance(from sourceLocation: CLLocation, to destinationLocation: CLLocationCoordinate2D) -> String? {
        let destination = CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        let distanceInMeters = sourceLocation.distance(from: destination)
        
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = .abbreviated
        return distanceFormatter.string(fromDistance: distanceInMeters)
    }
}





/*
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPlace = places[indexPath.row]
    
    // Konuma gitmek için MKPlacemark oluştur
    let placemark = MKPlacemark(coordinate: selectedPlace.coordinate, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = selectedPlace.name
    
    // Ayarlanan konuma git
    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
}
*/
