//
//  User.swift
//  Backstage
//
//  Created by Felix Tesche on 24.05.21.
//

import Foundation
import SwiftUI
import RealmSwift

struct User: Identifiable, Hashable {
    let partition : String
    
    let id      : Int
    let _id     : Int
    let name    : String
    var bands   : RealmSwift.List<BandDB>
}

extension User {
    init(userDB: UserDB) {
        partition = userDB.partition
        
        id      = userDB.id
        _id     = userDB._id
        name    = userDB.name
        bands   = userDB.bands
    }
}
