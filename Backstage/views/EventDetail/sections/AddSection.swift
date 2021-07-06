//
//  AddSection.swift
//  Backstage
//
//  Created by Felix Tesche on 19.01.21.
//

import SwiftUI

enum ActiveSheetCreate: Identifiable {
    case settlement, transport, contact, placeholder, checklist
    
    var id: Int {
        hashValue 
    }
}


struct AddSection: View {
    @Binding var eventReference : Int
    
    @State var activeSheet: ActiveSheetCreate?
    
    @EnvironmentObject var eventStore       : EventStore
    @EnvironmentObject var checklistStore   : ChecklistStore
    @EnvironmentObject var venueStore       : VenueStore
    
    @State var sheetHasBeenFinished : Bool = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(2)
                    .frame(width: 50, height: 4)
                Spacer()
            }
            .padding(.top, 16)
            HStack {
                VStack (alignment: .leading){
                    Text("Add new Section")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                    Text("Here you can add some new Items to your Event")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal, 16)
                }
                
                Spacer()
            }.padding(.top, 32)
            
            Divider()
            
            let featureStrings = ["Ankündigung", "Linkliste" , "Checklist", "Kontakte", "Transport", "Wichtiger Ort", "Abstimmung", "Notizen"]
            let featureIcons = ["plus.message", "link", "checkmark", "person.2.fill", "car.2.fill" ,"bed.double.fill" , "list.bullet", "note.text.badge.plus"]
            let featureToggles: [ActiveSheetCreate] = [.placeholder, .placeholder, .checklist, .contact, .transport, .settlement, .placeholder, .placeholder]
            
            GridStack(rows: 4, columns: 4) { row, col in
                let currentIndex = (row * 4 + col)
                if(currentIndex < featureStrings.count) {
                    Button(action: {
                        if(featureToggles[currentIndex] == .checklist) {
                            self.createChecklist()
                            return;
                        }
                        self.activeSheet = featureToggles[currentIndex]
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .frame(width: 64, height: 64)
                                Image(systemName: "\(featureIcons[currentIndex])")
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color.white)
                            }
                            Text("\(featureStrings[currentIndex])")
                                .font(.caption)
                                .foregroundColor(Color.primaryDark)
                        }
                        .frame(width: 92, height: 92)
                    }
                }
            }.padding(.vertical, 16)
            
            Divider()
                .sheet(item: $activeSheet, onDismiss: {
                    if(sheetHasBeenFinished) {
                        self.mode.wrappedValue.dismiss()
                    }
                }) { item in
                    switch item {
                    case .settlement:
                        let proposedDate = eventStore.findByID(id: eventReference)?.date ?? Date()
                        let dayPlusOne = Calendar.current.date(byAdding: .day, value: 1, to: proposedDate)!
                        AddSettlement (
                            settlementArrivalDate: proposedDate,
                            settlementDepartureDate: dayPlusOne,
                            proposedDate: proposedDate,
                            locationService: LocationService(),
                            eventReference: eventReference
                        )
                    case .transport:
                        AddTransport(
                            sheetHasBeenFinished: $sheetHasBeenFinished,
                            eventReference: eventReference
                        )
                    case .contact:
                        AddPerson(
                            eventReference: eventReference
                        )
                    case .checklist:
                        AddChecklist(
                            eventReference: eventReference
                        )
                    case .placeholder:
                        Text("⚠️ Hier entsteht gerade eine neue Internetpräsenz. Bitte senden sie uns doch ein bitte ein Fax. (Die Nummer finden sie auf unserer Website) ⚠️ ")
                            .multilineTextAlignment(.leading)
                    }
                }
            Spacer()
        }
    }
    
    func createChecklist() {
        mode.wrappedValue.dismiss()
        
        let id = UUID().hashValue
        
        checklistStore.create(id: id, name: "")
        
        guard let checklist = checklistStore.findByID(id: id) else {
            return
        }
        
        guard let event = eventStore.findByID(id: eventReference) else {
            return
        }
        
        eventStore.addChecklist(event: event, checklist: checklist)
    }
}
