//
//  Progression.swift
//  SeniorComps
//
//  Created by Hilary on 11/5/21.
//

import Foundation

struct Progression : Codable, Hashable, Identifiable {
    var id : Int
    var name : String
    var BPM : Int
    
    var steps : [Step]
    
    struct Step : Codable, Hashable {
        var interval : Range<Double>
        var duration : Int
    }
}
