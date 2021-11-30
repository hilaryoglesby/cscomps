//
//  Warmup.swift
//  SeniorComps
//
//  Created by Hilary on 11/5/21.
//

import Foundation
import AudioKitEX
import AudioKit
import UIKit
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI
import AudioKitUI
import WebKit
import Combine

class ProgressionData : ObservableObject {
    var steps: Progression = load("pentatonic.json")
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func generateProgression() -> [AUValue] {
    var starting_note_index = 0
    let starting_octave = 4.0
    let progression = [[0, 1000], [2, 1000], [2, 1000], [1, 1000], [2, 1000]]
    let frequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    var steps : [AUValue] = []
    
    for i in 0 ..< progression.count {
        starting_note_index +=  progression[i][0]
        steps.append(Float(frequencies[starting_note_index] * starting_octave * starting_octave))
    }

    return steps
}

struct WarmupData {
    var steps: [AUValue] = generateProgression()
    var duration : AUValue = 1
    var isPlaying : Bool = false
    var frequency: AUValue = 440
    
}

class WarmupPlayer: ObservableObject {
    let engine = AudioEngine()
    var voc = Oscillator()
    
    func noteOn(note: MIDINoteNumber) {
        data.isPlaying = true
        data.frequency = note.midiNoteToFrequency()
    }

    func noteOff(note: MIDINoteNumber) {
        data.isPlaying = false
    }
    
    @Published var data = WarmupData() {
        didSet {
            if data.isPlaying {
                voc.start()
                voc.amplitude = 0.1
                
                for i in 0 ..< data.steps.count {
                    voc.$frequency.ramp(to: data.steps[i], duration: data.duration)
                }
                
            }
            else {
                voc.amplitude = 0.0
            }
        }
    }
    
    init() {
            engine.output = voc
        }
        func start() {
            do {
                voc.amplitude = 0.2
                try engine.start()
            } catch let err {
                Log(err)
            }
        }

        func stop() {
            voc.stop()
            engine.stop()
        }
}

struct WarmupView: View {
    @StateObject var conductor = WarmupPlayer()
    
    var steps = generateProgression()
    
    var body: some View {
        VStack {
            Text(self.conductor.data.isPlaying ? "STOP" : "START").onTapGesture {
                            self.conductor.data.isPlaying.toggle()
                        }
            NodeOutputView(conductor.voc)
                    }.navigationBarTitle(Text("Vocal Tract"))
                    .padding()
                    .onAppear {
                        self.conductor.start()
                    }
                    .onDisappear {
                        self.conductor.stop()
                    }
    }
}
