//
//  MusicNote.swift
//  SeniorComps
//
//  Created by Hilary on 11/6/21.
//

import Foundation
import SwiftUI
import CoreGraphics

struct MusicNote: View {
    
    var index: Int
    var size: Int
    var height: CGFloat
    var range: Range<Double>
    var overallRange: Range<Double>
    var notes: [String]
    var intervals: [Int]
    @Binding var indexPlaying : Int
    @Binding var flatNotes : [Int]
    @Binding var sharpNotes : [Int]
    

    var heightRatio: CGFloat {
        max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 0.15)
    }

    var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / magnitude(of: overallRange))
    }

    var body: some View {
        
        VStack {
            Text("\u{2669}")
                .font(.system(size: 55))
                .frame(width: 30, height: 40)
                .offset(x: 35, y: height * -offsetRatio * 0.8)
                .foregroundColor(indexPlaying == index ? .blue : (flatNotes.contains(index) ? .red : .black))
            Spacer()
            Text("\(notes.isEmpty ? "Hold" : notes[index])").offset(x: 35, y: 0).fixedSize(horizontal: true, vertical: true)
        }
    }
    
}

