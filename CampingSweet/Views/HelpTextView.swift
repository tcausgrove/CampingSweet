//
//  HelpTextView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/13/25.
//

import SwiftUI

struct HelpTextView: View {
    var helpSection: HelpSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch helpSection {
            case .camperScreen:
                Group {
                    Text("Options on Campers Screen")
                        .font(.title2)
                    Text("- Tap on the plus to add a camper")
                    Text("- Tap on a camper to select it for the log book")
                    Text("- Long press on a camper to edit its information")
                    Text("- Tap on the ellipsis (three dots) to delete or archive a camper")
                    Text("- Archived campers are kept at the bottom; tap the ellipsis to unarchive them or delete them")
                }
                
            case .logBookScreen:
                Group {
                    Text("Log Book")
                        .font(.title2)
                    Text("- Scroll up or down for more trips")
                    Text("- Tap on the plus to add a log entry")
                    Text("- Long press on a log entry to edit its information")
                    Text("- Trips can be imported or exported from/to a CSV file")
                    Text("- For more information about the CSV format, see the README")
                }
                
            case .settingsScreen:
                Group {
                    Text("Settings")
                        .font(.title2)
                    Text("- The DISPLAY section settings only affects data presentation")
                    Text("- Use Decimal degrees setting if your coordinates look like 36.16664 -105.96667")
                    Text("- Use Degrees minutes seconds setting if your coordinates look like 36°10'40.5\"N 105°58'17.3\"W")
                    Text("- Latitude and longitude should NOT be separated by commas")
                    Text("- The option to export CSV files should help in determining the format for importing data")
                }
            }
        }
        .padding(.leading, 16)
    }
}

#Preview {
    HelpTextView(helpSection: .settingsScreen)
}
