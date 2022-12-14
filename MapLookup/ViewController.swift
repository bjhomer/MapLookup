//
//  ViewController.swift
//  MapLookup
//
//  Created by BJ Homer on 2/6/16.
//  Copyright © 2016 BJ Homer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var modePicker: UISegmentedControl!

    var pin: MKAnnotation?
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        mapView.showsUserLocation = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedMap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    func tappedMap(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == .recognized else {
            return
        }
        
        let point = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        if modePicker.selectedSegmentIndex == 0 {
            self.showGeocode(for: coordinate)
        }
        else {
            self.showPointsOfInterest(for: coordinate)
        }
    }

    func showGeocode(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        pin = location
        geocoder.reverseGeocodeLocation(location) { (maybePlacemarks, error) -> Void in
            guard let placemark = maybePlacemarks?.first else {
                return
            }

            let controller = self.storyboard!.instantiateViewController(withIdentifier: "DetailsView") as! LocationDetailsViewController
            controller.placemark = placemark

            self.show(controller, sender: nil)
        }
    }

    func showPointsOfInterest(for coordinate: CLLocationCoordinate2D) {
        let request = MKLocalPointsOfInterestRequest(center: coordinate, radius: 100)
        request.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.parking])

        Task {
            let search = MKLocalSearch(request: request)
            
            do {
                let response = try await search.start()

                let view = MapItemsView(searchPoint: coordinate, mapItems: response.mapItems)
                let controller = UIHostingController(rootView: view)
                self.show(controller, sender: nil)
            }
            catch {
                print("Error searching: \(error)")
            }
        }
    }
}


extension CLLocation: MKAnnotation {}
