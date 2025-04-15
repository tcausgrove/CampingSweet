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
        VStack(alignment: .leading) {
                Text("CampingSweet Help")
                    .font(.title)
                    .padding(12)

                Group {
                    Text("Campers")
                        .font(.title2)
                    Text("- Click the plus to add a camper")
                    Text("- Long press on a camper to edit its information")
                }
                
                Group {
                    Text("Log Book")
                        .font(.title2)

                }

                Group {
                    Text("Settings")
                        .font(.title2)
                }
                
                Spacer()
                
            }
    }
}

#Preview {
    HelpView()
}
