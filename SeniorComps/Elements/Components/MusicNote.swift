//
//  MusicNote.swift
//  SeniorComps
//
//  Created by Hilary on 11/6/21.
//

import Foundation
import SwiftUI
import CoreGraphics

struct MusicNote: View, Equatable {
    var index: Int
    var color: Color
    var size: Int
    var height: CGFloat
    var range: Range<Double>
    var overallRange: Range<Double>
    var notes: [String]

    var heightRatio: CGFloat {
        max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 0.15)
    }

    var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / magnitude(of: overallRange))
    }

    var body: some View {
        VStack {
            Text("\u{2669}")
                .font(.system(size: 66))
                .frame(width: 50, height: 40)
                .offset(x: 50, y: height * -offsetRatio * 3)
            Spacer()
            Text("\(notes.isEmpty ? "Hold" : notes[index])").offset(x: 50, y: 0)
        }
    }
    
}

