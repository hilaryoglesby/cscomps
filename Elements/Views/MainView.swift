//
//  MainView.swift
//  SeniorComps
//
//  Created by Hilary on 11/28/21.
//

import Foundation
import SwiftUI

struct MainView : View {
    
    var body : some View {
        NavigationView {
            List {
                NavigationLink("Tune", destination: TunerView())
                NavigationLink("Warm Up", destination: ProgressionEvaluateView())
            }
            .navigationTitle("Features")
        }
    }
}
