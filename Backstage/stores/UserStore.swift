//
//  TransportStore.swift
//  Backstage
//
//  Created by Felix Tesche on 07.12.20.
//

import Foundation
import RealmSwift
import SwiftUI

final class UserStore: ObservableObject {
    @EnvironmentObject var bandStore : BandStore
    
    private var results: Results<UserDB>
    
    var users: [User] {
        results.map(User.init)
    }
    
    // Load Items from the Realm Database
    init(realm: Realm) {
        results = realm.objects(UserDB.self)
    }
    
    func findByID (id: Int) -> UserDB! {
        do {
            let partitionValue = "all-the-data"
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            return try Realm(configuration: configuration).object(ofType: UserDB.self, forPrimaryKey: id)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - CRUD Actions
extension UserStore {
    func create(userID: Int, name: String) {
        
        objectWillChange.send()
        
        do {
            let partitionValue = "all-the-data"
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try Realm(configuration: configuration)
            
            let refDB = UserDB()
            refDB.id            = userID
            refDB._id           = userID
            refDB.name          = name

                        
            realmSync.setCurrentUser(value: userID)

            try realm.write {
                realm.add(refDB)
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }
    
    func delete(indexSet: IndexSet) {
        objectWillChange.send()
        
        do {
            let partitionValue = "all-the-data"
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try Realm(configuration: configuration)
        
            indexSet.forEach ({ index in
                try! realm.write {
                    realm.delete(self.results[index])
                }
            })
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func removeBand(userID: Int, index: Int) {
        objectWillChange.send()
        
        if(index == nil) { print("Cannot Remove Band from User — index parameter was not provided");  return }
        
        let previousUser = self.findByID(id: userID)!
        
        do {
            let partitionValue = "all-the-data"
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try Realm(configuration: configuration)
            
            try realm.write {
                let updatedUser = UserDB()
                
                updatedUser.bands.append(objectsIn: previousUser.bands)
                updatedUser.bands.remove(at: index)
                
                realm.create(UserDB.self,
                                 value: [
                                    "_id": userID,
                                    "id" : userID,
                                    "bands": updatedUser.bands],
                                 update: .modified)
                
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func addBand(user: UserDB, band: BandDB? = nil) {
        objectWillChange.send()
        
        if(band == nil) { print("Cannot add Band to User — band parameter was not provided");  return }
        
        let previousUser = user
        
        do {
            let partitionValue = "all-the-data"
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try Realm(configuration: configuration)
            
            try realm.write {
                let updatedUser = UserDB()
                
                updatedUser.bands.append(objectsIn: previousUser.bands)
                updatedUser.bands.append(band!)

                realm.create(UserDB.self,
                                 value: [
                                    "_id": previousUser.id,
                                    "id" : previousUser.id,
                                    "bands": updatedUser.bands],
                                 update: .modified)
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    
    // Updated eine gegebene Task. Dafür wird die ID benötigt,
    // welche in der Datenbank danach sucht und dann nach den mitgegebenen
    // Parametern aktualisiert.
    /// text und isDone sind hierbei optional
    func update(userID: Int, name: String? = nil, band: BandDB? = nil) {
        // TODO: Add Realm update code below
        objectWillChange.send()
        
        let previousUser = self.findByID(id: userID)!
        
        print("ADDING BAND TO USER \(band?.name)")
        
        do {
            let partitionValue = "all-the-data"
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try Realm(configuration: configuration)
            
            try realm.write {
                let updatedUser = UserDB()
                updatedUser.id  = userID

                if(name == nil) {
                    updatedUser.name = previousUser.name
                } else {
                    updatedUser.name = name!
                }
                if(band == nil) {
                    updatedUser.bands = previousUser.bands
                } else {
                    updatedUser.bands.append(objectsIn: previousUser.bands)
                    updatedUser.bands.append(band!)
                }

                realm.create(UserDB.self,
                             value: [
                                "_id": userID ,
                                "id" : userID,
                                "bands": updatedUser.bands],
                             update: .modified)
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
}
