//
//  HelpView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/20/25.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var helpSection: HelpSection = .camperScreen
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("CampingSweet Help")
                    .font(.title)
                    .padding(12)
                
                Picker("Title key", selection: $helpSection, content: {
                    ForEach(HelpSection.allCases) { theSection in
                        Text(theSection.rawValue.capitalized)
                    }
                })
                .pickerStyle(MenuPickerStyle())

//                Menu {
//                    Picker(selection: $helpSection) {
//                        ForEach(HelpSection.allCases) { theSection in
//                            Text(theSection.rawValue.capitalized)
//                        }
//                    } label: { }
//                } label: {
//                    Text("\(helpSection.rawValue.capitalized) \(Image(systemName: "chevron.up.chevron.down"))")
//                        .font(.title3)
//                }
                HelpTextView(helpSection: helpSection)
                Spacer()
            }
//            .pickerStyle(.wheel)
        }
    }
}

#Preview {
    HelpView()
}
