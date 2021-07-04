//
//  ChecklistStore.swift
//  Backstage
//
//  Created by Felix Tesche on 07.12.20.
//

import Foundation
import RealmSwift
import SwiftUI

final class ChecklistStore: ObservableObject {
    private var results: Results<ChecklistDB>
    
    var Checklists: [Checklist] {
        results.map(Checklist.init)
    }
    
    // Load Items from the Realm Database
    init(realm: Realm) {
        results = realm.objects(ChecklistDB.self)
    }
    
    func findByID (id: Int) -> ChecklistDB! {
        do {
            let partitionValue = "all-the-data"
            
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            return try Realm(configuration: configuration).object(ofType: ChecklistDB.self, forPrimaryKey: id)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - CRUD Actions
extension ChecklistStore {
    func create(id: Int, name: String) {
        
        objectWillChange.send()
        
        do {
            let partitionValue = "all-the-data"
            
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try Realm(configuration: configuration)
            
            let refDB = ChecklistDB()
            
            refDB.id            = id
            refDB._id           = id
            refDB.name          = name

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
    
    func deleteWithID (id: Int) {
        objectWillChange.send()
        
        do {
            let partitionValue = "all-the-data"
            
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try Realm(configuration: configuration)
            
            let object = realm.objects(ChecklistDB.self).filter("id = %@", id).first
            
            try! realm.write {
                if let obj = object {
                    realm.delete(obj)
                }
            }
        }
        catch let err {
            print(err.localizedDescription)
        }
    }
    
    func addChecklistItem (checklist: ChecklistDB? = nil, checklistInput: String, id: Int) {
        if(checklist == nil) { print("Cannot add Checklist Input to Chechlist, checklist parameter was not provided");  return }

        do {
            let partitionValue = "all-the-data"
            
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try! Realm(configuration: configuration)
            try! realm.write {
                let checklistItem = ChecklistItem()
                
                checklistItem._id = id
                
                checklistItem.label = checklistInput
                
                checklistItem.assignedUser = nil
                
                checklist!.items.append(checklistItem)
            }
        }
    }
    
    func updateChecklistItem (checklist: ChecklistDB? = nil, checklistItemID: Int, currentUser: UserDB? = nil) {
        if(checklist == nil) { print("Cannot add Checklist Input to Chechlist, checklist parameter was not provided");  return }

        do {
            let partitionValue = "all-the-data"
            
            let user = app.currentUser!
            let configuration = user.configuration(partitionValue: partitionValue)
            
            let realm = try! Realm(configuration: configuration)
            try! realm.write {
            
                // Irgendwie so, das gleiche gilt auch fürs löschen
                
                guard let checklistItem = checklist?.items.first(where: { $0._id == checklistItemID }) else {
                    return
                }
                
                if(checklistItem.isDone) {
                    checklistItem.isDone = false
                    checklistItem.assignedUser = nil
                } else {
                    checklistItem.isDone = true
                    checklistItem.assignedUser = currentUser
                }
            }
        }
    }
}
