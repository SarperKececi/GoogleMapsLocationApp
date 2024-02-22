//  ViewController.swift
//  GoogleMapsLocationApp
//
//  Created by Sarper Kececi on 21.02.2024.

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsUserLocation = true  // Enable showing the user's location on the map
        return mapView
    }()

    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.textColor = .black // or any other suitable color
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
       
        return searchTextField
    }()

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        
        searchTextField.delegate = self
        
       
    }
  

    func setupUI() {
        view.addSubview(mapView)
        view.addSubview(searchTextField)

        // TextField width constraint (e.g., 80% of the screen width)
        searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true

        // TextField height constraint (e.g., fixed height)
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // TextField horizontal center constraint
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        // TextField top constraint with a specified distance from the top of the view (e.g., 80 padding)
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true

        searchTextField.returnKeyType = .go

        // MapView width and height constraints
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        // MapView horizontal and vertical center constraints
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func getNearbyPlaces(with query: String) {
        mapView.removeAnnotations(mapView.annotations)

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        if let userLocation = locationManager.location {
            // Set the search region around the user's current location
            request.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        }

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else {
                print("Error searching for places: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let places = response.mapItems.map(PlaceAnnotation.init)
            places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            self?.presentPlacesSheet(places: places)
        }
    }

    func presentPlacesSheet(places : [PlaceAnnotation]) {
        guard let userLocation = locationManager.location else { return }
        
      let vc = PlacesViewController(userLocation: userLocation, places: places)
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            if #available(iOS 15.0, *) {
                sheet.detents = [.medium(), .large()]
            } else {
               
            }
            present(vc, animated: true)
        }
    }



}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates if needed
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = manager.location {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
                mapView.setRegion(region, animated: true)
            }
        case .denied, .restricted:
            print("Location permission denied or restricted. You can grant location permission from the app settings.")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            getNearbyPlaces(with: text) // Düzeltildi
        }
        return true
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? PlaceAnnotation else { return }

        let places = [annotation]
        presentPlacesSheet(places: places)
    }
}


