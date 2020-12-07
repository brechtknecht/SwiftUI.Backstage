

import SwiftUI

struct SelectionItemView: View {

    @Binding var selection: String
    
    @State var actionText = "Neuen Veranstalter hinzufügen"
    
    @State var options = ["Freddys Rummelbude", "Zirkus Frankenstein", "Marius Olle-GoKartBahn"]
    
    @State var addNewVenue = false

    // Import Store to have access to the Data
    @EnvironmentObject var store : VenueStore
    
    // Used for popping Navigation State
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View{
        VStack {
            Form {
                Section(
                    header: Text("VERGANENGE VERANSTALTER"),
                    footer: Text("Here is a detailed description of the setting.")
                ) {
        
                    ForEach(0 ..< store.venues.count) { index in
                        HStack{
                            Button(action: {
                                // Trigger Controller
                                self.selection  = store.venues[index].name
                                
                                // Pop Navigation State
                                self.mode.wrappedValue.dismiss()
                                
                                
                            }){
                                Text("\(store.venues[index].name)")
                            }
                            Spacer()
                            if (self.selection  ==  store.venues[index].name){
                                Image(systemName: "checkmark")
                            }
                        }

                    }
                }
            }
            Section {
                Button(action: {
                    self.addNewVenue.toggle()
                }) {
                    ButtonFullWidth(label: $actionText);
                }.sheet(isPresented: $addNewVenue) {
                    AddVenueForm()
                }
                
            }
            .padding(8)
        }


    }
}



class SelectVenueViewModel: ObservableObject {
    @Published var selectedOption: String = "Veranstaltungsort" {
        didSet {
            print("new option selected: \(selectedOption.description)")
        }
    }
}
