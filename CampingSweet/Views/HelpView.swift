//
//  HelpView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/20/25.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var theQuestion: HelpFAQ = .introQuestion

    var body: some View {
        NavigationView {
            VStack {
                Picker("FAQ", selection: $theQuestion) {
                    ForEach(HelpFAQ.allCases) { option in
                        Text(option.rawValue)
                    }
                }
                    
                Text(theQuestion.faqAnswer)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
            }
            .padding()
            .toolbar() {
                ToolbarItemGroup(placement: .navigation) {
                    Button(role: .cancel,
                           action: { dismiss() } ) {
                        Text("Done")
                    }
                }
            }
        }
    }
}

#Preview {
    HelpView()
}
