//
//  ButtonFullWidth.swift
//  Backstage
//
//  Created by Felix Tesche on 06.12.20.
//

import SwiftUI

struct ButtonFullWidth: View {
    @Binding var label: String
    
    var body: some View {
        HStack {
            Text("\(label)")
                .fontWeight(.semibold)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(14)
        .foregroundColor(.white)
        .background(ColorManager.primaryDark)
        .cornerRadius(8)
    }
}

struct ButtonFullWidth_Previews: PreviewProvider {
    @State static var label = "Testtext aus Preview"
    
    static var previews: some View {
        ButtonFullWidth(label: $label)
    }
}
