//
//  BandSignifierCard.swift
//  Backstage
//
//  Created by Felix Tesche on 30.05.21.
//

import SwiftUI
import CodeScanner

struct BandSignifierCard: View {
    @State var invalid: Bool = false
    @Binding var bandID : String
        
    @State private var isShowingScanner = false
    @State private var sheetNewBand: Bool = false
    
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var bandStore : BandStore
    
    @ObservedObject var user : UserDB = realmSync.user
    
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
                CodeScannerView(codeTypes: [.qr], simulatedData: "kQiMlPaIu6WVRCcDtH6xs5Kn", completion: self.handleScan)
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
                .background(ColorManager.primaryLight)
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
                let band = bandStore.findByBandReference(referenceString: decoded)
                            
                if(band == nil) { print("No Band found for your scan. — DECODED VALUE \(decoded)"); return }
                
                print("SCAN ADDING BAND \(band)")
                userStore.addBand(user: user, band: band)
                bandStore.addMember(band: band, member: user)
                
                
            case .failure(let error):
                print("Scanner didnt work \(error)")
        }
    }
    
    
    
    
    func setBandID() -> Void {
        print("\(self.bandID)")
        realmSync.setPartitionValue(value: self.bandID)
    }
}
