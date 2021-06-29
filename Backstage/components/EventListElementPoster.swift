
//
//  EventListElement.swift
//  Backstage
//
//  Created by Felix Tesche on 02.01.21.
//

import SwiftUI

struct EventListElementPoster: View {
    
    @State var event: Event
    @State var venue: VenueDB
    
    @EnvironmentObject var eventStore: EventStore
    
    @Environment(\.editMode) var editMode
    
    let CARD_WIDTH : CGFloat = 400
    let CARD_HEIGHT : CGFloat = 500
    
    @ObservedObject var viewModel = ViewModel()
    
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination:
                EventDetail(
                    eventID: .constant(event._id)
                )
            ) {
                ZStack {
                    Image(uiImage: Utilities.helpers.loadImageFromCDN(imageUUID: event.imageUUID, imageData: event.imageData))
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CARD_WIDTH, height: CARD_HEIGHT)
                        .cornerRadius(12)
                        .clipped()
                        .opacity(isEditing ? 0.4 : 1)
                    Image("PaperTexture")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: CARD_WIDTH, height: CARD_HEIGHT)
                        .aspectRatio(1.12, contentMode: .fill)
                        .cornerRadius(12)
                        .blendMode(.multiply)
                        .opacity(isEditing ? 0.4 : 1)
                    Image("EventFrame")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: CARD_WIDTH, height: CARD_HEIGHT)
                        .aspectRatio(1.12, contentMode: .fill)
                        .cornerRadius(12)
                        .opacity(isEditing ? 0.15 : 1)
                    
                    VStack (alignment: .center){
                        HStack {
                            Attendants(/* event.attendants */)
                            
                            Spacer()
                            
                            DateTag(date: event.date)
                                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
                                .padding(.trailing, 28.00)
                        }
                    
                        Spacer()
//                        Text(event.name)
                        Text(event.assignedBand.name)
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
                            .frame(width: CARD_WIDTH - 20)
                        Text(event.type.uppercased())
                            .font(.headline)
                            .fontWeight(.bold)
                            .tracking(2.54)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
                            .padding(.vertical, 4)
                            .frame(width: CARD_WIDTH - 20)
                    }
                    .padding(EdgeInsets(top: 24, leading: 12, bottom: 64, trailing: 12))
                }
                
            }
            .buttonStyle(PlainButtonStyle())
            if (isEditing) {
                HStack {
                    Button(action: {
                        print("Edit Event")
                    }) {
                        ZStack {    
                            Rectangle()
                                .fill(Color(.systemBlue))
                                .cornerRadius(4)
                            Text("Bearbeiten")
                                .frame(width: (CARD_WIDTH / 2) - 4, height: 42)
                                .foregroundColor(.white)
                        }
                        
                    }
                    Button(action: {
                        deleteEventByID(id: event.id)
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(Color(.red))
                                .cornerRadius(4)
                            Text("Löschen")
                                .frame(width: (CARD_WIDTH / 2) - 4, height: 42)
                                .foregroundColor(.white)
                        }
                        
                    }
                }
            }
        }
        .modifier(ToggleEditModeEffect(y: isEditing ? -10 : 0).ignoredByLayout())
        .contextMenu {
            Button(action: {
                deleteEventByID(id: event.id)
            }) {
                Text("Löschen")
                    .foregroundColor(.red)
                }
            }
        }
    
    
    struct ToggleEditModeEffect: GeometryEffect {
        var y: CGFloat = 0
        
        var animatableData: CGFloat {
            get { y }
            set { y = newValue }
        }
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            return ProjectionTransform(CGAffineTransform(translationX: 0, y: y))
        }
    }
    
    
    private func deleteEventByID(id: Int) {
        print("IndexSet : \(id)")
        eventStore.deleteWithID(id: id)
    }
}

extension EventListElementPoster {
    class ViewModel : ObservableObject {
        @Published var compressedImage : UIImage
        
        init() {
            self.compressedImage = UIImage()
        }
        
        func venueString (venue: VenueDB?) -> String {
            let venueName = venue!.name
            let venueLocation = venue!.location
            let venueDistict = venue!.street
            let venueCountry = venue!.country
            
            return venueName + ", " + venueLocation + " — " + venueDistict + " " + venueCountry
        }
    }
}

    

//struct EventListElement_Previews: PreviewProvider {
//    static var previews: some View {
//        EventListElement()
//    }
//}
