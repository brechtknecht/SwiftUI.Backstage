//
//  CreateNewEvent.swift
//  Backstage
//
//  Created by Felix Tesche on 06.12.20.
//

import SwiftUI

struct CreateNewEvent: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var eventName = ""
    @State var eventDate = Date()
    @State var eventType = 0
    
        
    @State static var label = "Event hinzufügen"
    
    
    @ObservedObject var selectVenueViewModel = SelectVenueViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack {
                Form {
                    Section(header: Text("Allgemeine Informationen")) {
                        TextField("Name", text: $eventName)
                        DatePicker(selection: $eventDate, in: ...Date(), displayedComponents: .date) {
                            Text("Datum")
                        }
                        Picker(selection: $eventType, label: Text("What is your favorite color?")) {
                            Text("Clubauftritt").tag(0)
                            Text("Festivalauftritt").tag(1)
                            Text("Tourauftritt").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 8)
                    }
                    
                    
                    // Custom Selection
                    Section(header: Text("Veranstaltungsort")) {
                        NavigationLink(destination:
                                        SelectionItemView(
                                            selection: $selectVenueViewModel.selectedOption
                                        )
                        ) {
                            Text("\(selectVenueViewModel.selectedOption.rawValue)")                            
                        }
                    }
                    
                    
                    Section(header: Text("Logistik und Transport")) {
                        Button(action: {
                            print("Buttontriggag")
                        }) {
                            Text("Fahrzeug auswählen")
                        }
                        Button(action: {
                            print("Buttontriggag")
                        }) {
                            Text("Übernachtung auswählen")
                        }
                    }
                    
                    
                }
                Section {
                    ButtonFullWidth(label: CreateNewEvent.$label)
                }
                .padding(8)
            }
            
            
            .navigationBarTitle("Event erstellen")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Fertig")
                }
            })
        }
    }
}

class SelectVenueViewModel: ObservableObject {
    @State var options = ["Erster", "Zweiter", "Dritter"]
    
    enum Option: String, Identifiable, CaseIterable, CustomStringConvertible {
        case LausbubenKulturverein
        case optionTwo
        case optionThree

        var id: Option {
            self
        }

        var description: String {
            rawValue.prefix(1).uppercased() + rawValue.dropFirst()
        }
    }

    @Published var selectedOption: Option = .LausbubenKulturverein {
        didSet {
            print("new option selected: \(selectedOption.description)")
        }
    }
}


struct CreateNewEvent_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewEvent()
    }
}
