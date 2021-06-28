//
//  BackstageApp.swift
//  Backstage
//
//  Created by Felix Tesche on 06.12.20.
//

import SwiftUI
import UIKit
import RealmSwift

let app = App(id: "backstage-pjhnz") // Global App Object for SYNCING data with and to LOGIN against
let realmSync = RealmSync()


@main
struct BackstageApp: SwiftUI.App {
    @StateObject var realmSyncUI = realmSync
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BandStore(realm: RealmPersistent.initializer()))
                .environmentObject(UserStore(realm: RealmPersistent.initializer()))
                .environmentObject(VenueStore(realm: RealmPersistent.initializer()))
                .environmentObject(
                    EventStore(
                        realm: RealmPersistent.initializer()
                    )
                )
                .environmentObject(SettlementStore(realm: RealmPersistent.initializer()))
                .environmentObject(TransportStore(realm: RealmPersistent.initializer()))
                .environmentObject(PersonStore(realm: RealmPersistent.initializer()))
                .environmentObject(TimetableStore(realm: RealmPersistent.initializer()))
                .environmentObject(TimeslotStore(realm: RealmPersistent.initializer()))
                
                .environmentObject(realmSync)
                .environment(\.realmConfiguration, self.initializeConfiguration())
                
        }
    }
    
    func initializeConfiguration () -> Realm.Configuration {
        if(app.currentUser != nil) {
            return app.currentUser!.configuration(partitionValue: "all-the-data")
        }
        return Realm.Configuration.defaultConfiguration
    }
    
    
}


