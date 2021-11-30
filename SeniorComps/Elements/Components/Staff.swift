//
//  Staff.swift
//  SeniorComps
//
//  Created by Hilary on 11/5/21.
//

import Foundation 
import SwiftUI
import CoreGraphics

struct Staff: View {
    var warmup: Progression
    var path: KeyPath<Progression.Step, Range<Double>>
    var notes: [String]

    var color: Color {
        switch path {
        default:
            return .black
        }
    }

    var body: some View {
        let data = warmup.steps
        let duration = data[0].duration
        let overallRange = rangeOfRanges(data.lazy.map { $0[keyPath: path] })
        let maxMagnitude = data.map { magnitude(of: $0[keyPath: path]) }.max()!
        let heightRatio = 1 - CGFloat(maxMagnitude / magnitude(of: overallRange))

        return GeometryReader { proxy in
            VStack {
                HStack(spacing: proxy.size.width / 120) {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, observation in
                        MusicNote(
                            index: index,
                            color: color,
                            size: duration,
                            height: proxy.size.height,
                            range: observation[keyPath: path],
                            overallRange: overallRange,
                            notes: notes
                        )
                    }
                    .offset(x: 0, y: proxy.size.height * heightRatio)
                }
            }
        }
    }
}

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
    where C.Element == Range<Double> {
    guard !ranges.isEmpty else { return 0..<0 }
    let low = ranges.lazy.map { $0.lowerBound }.min()!
    let high = ranges.lazy.map { $0.upperBound }.max()!
    return low..<high
}

func magnitude(of range: Range<Double>) -> Double {
    range.upperBound - range.lowerBound
}



