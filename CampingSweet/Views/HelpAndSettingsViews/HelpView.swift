//
//  HelpView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/20/25.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.dismiss) var dismiss
//    @State private var helpSection: HelpSection = .camperScreen
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("CampingSweet Help")
                    .font(.title)
                    .padding(12)

                ScrollView {
                    HelpTextView()
                }

                Spacer()
            }
        }
    }
}

#Preview {
    HelpView()
}
