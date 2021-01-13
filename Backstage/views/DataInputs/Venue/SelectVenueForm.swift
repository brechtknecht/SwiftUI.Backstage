import SwiftUI

struct SelectionItemView: View {
    
    @Binding var selection: String
    @Binding var location: String
    @Binding var selectedID: Int
    
    @State var actionText = "Neuen Veranstalter hinzufügen"
    
    @State var addNewVenue = false
    
    // Import Store to have access to the Data
    @EnvironmentObject var venueStore : VenueStore
    
    // Used for popping Navigation State
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        NavigationView {
            VStack {
            
                VStack {
                    Form {
                        Section(
                            header: Text("VERGANENGE VERANSTALTER"),
                            footer: Text("Here is a detailed description of the setting.")
                        ) {
                            List {
                                ForEach(venueStore.venues, id: \.id) { venue in
                                    HStack{
                                        Button(action: {
                                            // Trigger Controller
                                            self.selection  = venue.name
                                            
                                            self.location = venue.location + " " + venue.street + ", " + venue.country
                                            
                                            self.selectedID = venue.id
                                            
                                            // Pop Navigation State
                                            self.mode.wrappedValue.dismiss()
                                            
                                        }){
                                            VStack (alignment: .leading) {
                                                Text("\(venue.name)")
                                                    .foregroundColor(ColorManager.primaryDark)
                                                
                                                Text("\(venue.location) \(venue.street) \(venue.country)")
                                                    .foregroundColor(ColorManager.primaryDark)
                                                    .font(.body)
                                            }.padding(.vertical, 8)
                                        }
                                        Spacer()
                                        if (self.selection  ==  venue.name){
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }.onDelete(
                                    perform: delete
                                )
                            }.environment(\.editMode, editMode)
                        }
                    }
                    Spacer()
                    Section {
                        Button(action: {
                            self.addNewVenue.toggle()
                        }) {
                            ButtonFullWidth(label: $actionText);
                        }.sheet(isPresented: $addNewVenue) {
                            AddVenueForm(locationService: LocationService())
                        }
                    }
                    .padding(8)
                }
            }
        }.navigationBarItems(
            trailing: CEditButton()
                .disabled(venueStore.venues.count == 0)
        )
        .environment(\.editMode, editMode)
    }
    
    func delete(with indexSet: IndexSet) {
        venueStore.delete(indexSet: indexSet)
    }
}
                

struct SelectVenueForm_Previews: PreviewProvider {
    static var previews: some View {
        SelectionItemView(
            selection: .constant("Test"),
            location: .constant("Location"),
            selectedID: .constant(0202020)
        )
    }
}
