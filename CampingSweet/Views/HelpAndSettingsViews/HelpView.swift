//
//  HelpView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/20/25.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
            VStack {
                Text("CampingSweet Help")
                    .font(.title)
                    .padding(12)

                ScrollView {
                    HelpTextView()
                }

                Spacer()
            }
            .background(BackgroundView()).scrollContentBackground(.hidden)
            .navigationTitle(Text("CampingSweet Help"))
    }
}

#Preview {
    HelpView()
}
