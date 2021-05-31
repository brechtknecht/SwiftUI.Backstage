//
//  Band.swift
//  Backstage
//
//  Created by Felix Tesche on 24.05.21.
//

import Foundation
import SwiftUI
import RealmSwift

struct Band: Identifiable, Hashable {
    let id          : Int
    let _id         : Int
    let name        : String
    let members     : RealmSwift.List<Int>
    let bandRef     : String
    let adminID     : Int
}

extension Band {
    init(bandDB: BandDB) {
        id          = bandDB.id
        _id         = bandDB._id
        name        = bandDB.name
        members     = bandDB.members
        bandRef     = bandDB.bandRef
        adminID     = bandDB.adminID
    }
}
