//
//  HelpTextView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/13/25.
//

import SwiftUI

struct HelpTextView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let overviewText = """
                CampingSweet helps you keep track of campsites you have visited.  It includes a log book of campsites, maps of campsites visited and charts of overall camper usage.  The app allows more than one camper; for each camper, the total miles driven and number of nights used are displayed.
                
                """
            
                let camperText = """
                From here you can add, delete, or archive different campers.  The camper's mileage and number of nights used is displayed.  One camper is the Selected Camper for use by the Log Book and Maps display. For more information see the app's [help page](https://sites.google.com/view/tcausgrove/campingsweet/campingsweet-support).
                
                """

            let mapsText = """
            A map of campsites is displayed with pins at each campsite.  Includes a menu for narrowing the displayed sites to either a certain year or all years.  The map shows only sites for the selected camper.
            """
            
            let logbookText = """
                This shows the campsited visited by the Selected camper.  Each stop may be edited, deleted, or shown in Apple Maps.  See the Settings screen for Card display vs. List display.
                
                """

            let settingsText = """
                User preferences are set here, including distance in miles vs. kilometers and date format.  The second section of settings are for importing CSV files.  For more information about CSV export or import, see the [CSV Import section of the help page](https://sites.google.com/view/tcausgrove/campingsweet/campingsweet-support#h.uq7zpiapgygn).  
                
                """

            Text("Overview")
                .font(.title2.bold())
            Text(LocalizedStringKey(overviewText))

            Text("Campers screen")
                .font(.title2.bold())
            Text(LocalizedStringKey(camperText))
            
            Text("Log Book screen")
                .font(.title2.bold())
            Text(LocalizedStringKey(logbookText))

            Text("Maps screen")
                .font(.title2.bold())
            Text(LocalizedStringKey(mapsText))

            Text("Settings screen")
                .font(.title2.bold())
            Text(LocalizedStringKey(settingsText))
        }
        .padding([.leading, .trailing], 10)
    }
}

#Preview {
    HelpTextView()
}
