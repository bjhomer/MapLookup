//
//  MapItemsView.swift
//  MapLookup
//
//  Created by BJ Homer on 8/11/22.
//  Copyright © 2022 BJ Homer. All rights reserved.
//

import SwiftUI
import MapKit
import Contacts

struct MapItemsView: View {
    private var searchPoint: CLLocation
    private var items: [Item]
    @State private var selectedItem: Item?

    init(searchPoint: CLLocationCoordinate2D, mapItems: [MKMapItem]) {
        self.searchPoint = CLLocation(latitude: searchPoint.latitude, longitude: searchPoint.longitude)
        self.items = mapItems
            .enumerated()
            .map { Item(mapItem: $0.element, index: $0.offset)}
    }

    private struct Item: Identifiable, Hashable {
        var mapItem: MKMapItem
        var index: Int

        var id: Int { index }
    }

    var body: some View {
        let distanceFormatter = MKDistanceFormatter()

        List(items, selection: $selectedItem) { item in
            Button(action: { selectedItem = item }) {
                let coordinate = item.mapItem.placemark.coordinate
                let thisLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

                let distance = thisLocation.distance(from: searchPoint)

                Row(title: item.mapItem.name ?? "", value: distanceFormatter.string(fromDistance: distance))
            }
        }
        .sheet(item: $selectedItem) { item in
            MapItemView(item: item.mapItem)
        }
    }
}

struct MapItemView: View {
    var item: MKMapItem

    var body: some View {
        List {
            Row(title: "Name", value: item.name)
            Row(title: "Category", value: item.pointOfInterestCategory?.rawValue)
            Row(title: "URL", value: item.url?.host)
            Row(title: "Phone", value: item.phoneNumber)

            if let address = item.placemark.postalAddress {
                let formatter = CNPostalAddressFormatter()
                let address = formatter.string(from: address)
                Row(title: "Address", value: address)
            }
        }
    }

}
struct Row: View {
    var title: String
    var value: String?

    var body: some View {
        HStack {
            Text(title).font(.headline)
            Spacer()
            Text(value ?? "")
        }
    }
}

