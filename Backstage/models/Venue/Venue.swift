//
//  Venue.swift
//  Backstage
//
//  Created by Felix Tesche on 07.12.20.
//

import Foundation
import CoreLocation

struct Venue: Identifiable, Hashable {
    let _id: Int
    let id: Int
    let name: String
    let location: String
    let street: String
    let country: String
}

extension Venue {
    init(venueDB: VenueDB) {
        _id = venueDB._id
        id = venueDB.id
        name = venueDB.name
        location = venueDB.location
        street = venueDB.street
        country = venueDB.country
    }
}
