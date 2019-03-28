//
//  ViewController.swift
//  sunriseSunset sunrise sunset
//
//  Created by Igor on 3/25/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces


class MainViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchCityName: UITextField!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var curentTime: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var mapLocation: MKMapView!
    
    private var locationManager = CLLocationManager()
   
    fileprivate var lat: Double = 0.0
    fileprivate var lng: Double = 0.0
   
    private var getCurentTime: String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        return "\(hour):\(minutes)"
    }
    
    @IBAction func textFieldTapped(_ sender: UITextField) {
        searchCityName.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestWhenInUseAuthorization()

        self.searchCityName.delegate = self

        searchCityName.layer.cornerRadius = 10
        mapLocation.layer.cornerRadius = mapLocation.frame.size.width / 15
        
        var placeHolder = NSMutableAttributedString()
        let placeHolderMessage  = "Enter city name"
        placeHolder = NSMutableAttributedString(string:placeHolderMessage, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 25.0)!])
        
        placeHolder.addAttribute(NSAttributedString.Key.foregroundColor,
                                 value: UIColor.white,
                                 range: NSRange(location: 0,
                                                length: placeHolderMessage.characters.count)
        )
        searchCityName.attributedPlaceholder = placeHolder

        self.mapLocation.isZoomEnabled = false;
        self.mapLocation.isScrollEnabled = false;
        self.mapLocation.isUserInteractionEnabled = false;

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func updateUI(lat: Double, lng: Double, sunset: String, sunrise: String) {
        self.sunset.text = "Sunset: \(sunset)"
        self.sunrise.text = "Sunrise: \(sunrise)"
        self.latitude.text = String("Latitude: \(lat)")
        self.longitude.text = String("Longitude: \(lng)")
        self.curentTime.text = "Curent time:" + getCurentTime
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.mapLocation.setRegion(region, animated: true)
    }
    
    //MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationValue: CLLocationCoordinate2D? = manager.location?.coordinate
  
        if let lng = locationValue?.longitude, let lat = locationValue?.latitude {
        
            RequestManager.getSunriseSunsetTime(lat: "\(lat)", lng:"\(lng)") {[weak self] (results) in
                DispatchQueue.main.async {
                    self?.updateUI(lat: lat,
                                  lng: lng,
                                  sunset: results.results.sunset,
                                  sunrise: results.results.sunrise
                    )
                }
                self?.locationManager.stopUpdatingLocation()
            }
        }
    }
}

extension MainViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        lat = Double(place.coordinate.latitude)
        lng =  Double(place.coordinate.longitude)
        
        searchCityName.text = place.name
        
        RequestManager.getSunriseSunsetTime(lat: "\(lat)", lng:"\(lng)") {[weak self] (results) in
            DispatchQueue.main.async {
                self?.updateUI(lat: (self?.lat)!,
                               lng: (self?.lng)!,
                               sunset: results.results.sunset,
                               sunrise: results.results.sunset
                )
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
