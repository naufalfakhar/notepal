//
//  CalculatedView.swift
//  notepal
//
//  Created by Hansen Yudistira on 16/07/24.
//

import SwiftUI

struct CalculatedView: View {
    var displayedScheduled: Int
    var displayedDone: Int
    var displayedMissed: Int
    
    var body: some View {
        VStack {
            VStack {
                Text("Scheduled")
                    .font(.footnote)
                Text("\(displayedScheduled)")
                    .font(.title3)
            }
            VStack {
                Text("Done")
                    .font(.footnote)
                Text("\(displayedDone)")
                    .font(.title3)
                    .foregroundStyle(Color.green)
            }
            VStack {
                Text("Missed")
                    .font(.footnote)
                Text("\(displayedMissed)")
                    .font(.title3)
                    .foregroundStyle(Color.red)
            }
        }
        .fontWeight(.bold)
        .padding()
        .multilineTextAlignment(.center)
    }
}

