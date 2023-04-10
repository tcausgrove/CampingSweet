//
//  LogBookView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct LogBookView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var addingLogEntry = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.trips) { trip in
                    VStack(alignment: .leading) {
                        Text("Title: \(trip.title)")
                        Text("When: \(trip.startDate.formatted())")
                        Text("Duration: \(trip.duration)")
                    }
                    .padding()
                }
            }
            .toolbar() {
                ToolbarItem {
                    Button(action: { addingLogEntry.toggle()}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $addingLogEntry, content: {
                AddLogBookEntryView()
            })
            .navigationTitle("Log Book")
        }

    }
}

//struct LogBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogBookView()
//    }
//}
