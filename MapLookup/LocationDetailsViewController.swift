//
//  LocationDetailsViewController.swift
//  MapLookup
//
//  Created by BJ Homer on 2/6/16.
//  Copyright © 2016 BJ Homer. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController {

    var placemark: CLPlacemark! {
        didSet { updateDetails() }
    }
    private let detailsOrder = [
        "name",
        "timeZone.name",
        "subThoroughfare",
        "thoroughfare",
        "locality",
        "subLocality",
        "administrativeArea",
        "subAdministrativeArea",
        "country",
        "inlandWater",
        "ocean",
    ]
    private var details: [(String, String)] = []
    
    private func updateDetails() {
        defer { self.tableView?.reloadData() }
        guard placemark != nil else {
            details = []
            return
        }
        
        var d: [(String, String)] = []
        for key in detailsOrder {
            guard let value = placemark.value(forKeyPath: key) as? String else { continue }
            d.append( (key, value) )
        }
        details = d
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let (key, value) = details[indexPath.row]
        
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
