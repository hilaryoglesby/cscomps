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
    @State private var showDetail = false

    var body: some View {
        VStack {
            HStack {
                Staff(warmup: warmup, path: \.interval, notes: notes)
                    .frame(width: 50, height: 30)

                Spacer()
            }
        }
    }
}

