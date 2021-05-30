//
//  BandSignifierCard.swift
//  Backstage
//
//  Created by Felix Tesche on 30.05.21.
//

import SwiftUI
import CodeScanner

struct BandSignifierCard: View {
    @State var bandID : String = realmSync.partitionValue
    @State var invalid: Bool = false
    
    @State private var isShowingScanner = false
    @State private var sheetNewBand: Bool = false
    
    var body: some View {
        VStack {
            Text("Create new band").font(.title3).fontWeight(Font.Weight.semibold)
            Spacer(minLength: 16)
            Button(action: {
                self.sheetNewBand = true
            }) {
                ButtonFullWidth(label: .constant("Register your band"));
            }
            .sheet(isPresented: $sheetNewBand,
                    onDismiss: { print("finished!") },
                    content: { NewBand() })
        }
        .padding(.all, 8)
        .background(ColorManager.backgroundForm)
        .cornerRadius(8.0)
        
        Spacer(minLength: 32)
        
        VStack {
            Text("Join existing band").font(.title3).fontWeight(Font.Weight.semibold)
            Spacer(minLength: 16)
            Button(action: {
                self.isShowingScanner = true
                
            }) {
                ButtonFullWidth(label: .constant("Scan Band Code"), icon: "qrcode.viewfinder");
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "band123", completion: self.handleScan)
            }
            Text("or enter manually").font(Font.callout)
            
            TextField(LocalizedStringKey("Enter existing Band Code"),
                      text: $bandID,
                      onEditingChanged: { changing in
                        if !changing {
                            self.bandID = self.bandID.trimmingCharacters(in: .whitespacesAndNewlines)
                        } else {
                            self.invalid = false
                        }},
                      onCommit: self.setBandID)
                .padding(.all, 8)
                .background(Color.white)
                .cornerRadius(8.0)
                .font(.system(size: 14, design: .monospaced))
                .multilineTextAlignment(.center)
                .autocapitalization(.none)
            
            Text("This is your unique Band ID, share it to let your other bandmembers come on board").font(Font.caption2)
        }
        .padding(.all, 8)
        .background(ColorManager.backgroundForm)
        .cornerRadius(8.0)
    }
    
    func handleScan (result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
            case .success(let decoded):
                realmSync.setPartitionValue(value: decoded)
                self.bandID = decoded
                
                self.setBandID()
            case .failure(let error):
                print("Scanner didnt work \(error)")
        }
    }
    
    struct NewBand: View {
        @Environment (\.presentationMode) var presentationMode
        
        @State var bandName : String = ""
        @State var username : String = ""
        
        @EnvironmentObject var userStore : UserStore

        var body: some View {
            
            NavigationView {
                VStack {
                    VStack {
                        Form {
                            Section(
                                header: Text("Band Info")
                            ){
                                TextField("Band Name",text: $bandName)
                            }
                            Section {
                                HStack {
                                    Image(systemName: "checkmark.square.fill")
                                        .foregroundColor(Color.green)
                                    Text("Already existing Events will be imported")
                                }
                            }
                            
                            Section(
                                header: Text("Info about you")
                            ){
                                TextField("Your name",text: $username)
                            }
                        }
                        Spacer()
                        Section {
                            Button(action: {
                                userStore.create(name: self.username, bandRef: Utilities.helpers.generateBandID())
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                ButtonFullWidth(label: .constant("Create new Band"));
                            }
                        }.padding(.horizontal, 16)
                    }
                }
                .navigationTitle(Text("Create new Band"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    
    func setBandID() -> Void {
        print("\(self.bandID)")
        realmSync.setPartitionValue(value: self.bandID)
    }
}
