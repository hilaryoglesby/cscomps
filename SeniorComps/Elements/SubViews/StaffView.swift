//
//  StaffView.swift
//  SeniorComps
//
//  Created by Hilary on 11/6/21.
//

import Foundation

import SwiftUI
import UIKit

struct StaffView: View {
    var warmup: Progression
    var notes: [String]
    var intervals: [Int]
    @State private var showDetail = false
    @Binding var indexPlaying : Int
    @Binding var flatNotes: [Int]
    @Binding var sharpNotes : [Int]

    var body: some View {
        VStack {
            HStack {
                Staff(warmup: warmup, path: \.interval, notes: notes, intervals: intervals, indexPlaying: $indexPlaying, flatNotes: $flatNotes, sharpNotes: $sharpNotes)
                    .frame(width: 100, height: 100)
                Spacer()
            }
            Text("\(indexPlaying)")
//            Text("\(notes.count)")
//            Text("\(intervals.count)")
        }
    }
}


