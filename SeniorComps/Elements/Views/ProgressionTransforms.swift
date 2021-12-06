//
//  ProgressionTransforms.swift
//  SeniorComps
//
//  Created by Hilary on 11/22/21.
//

import Foundation
import AudioKitEX
import AudioKit
import UIKit
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

struct ProgressionTransformData {
    var prog : Progression = load("pentatonic.json")
    var note_names : [String] = []
    var pitch: Float = 0.0
    var intervals: [Int] = []
    var amplitude: Float = 0.0
    var start_note = 0
    var start_oct = 3
    var note_sharps = " "
    var note_flats = " "
    var prog_note: String = "C4"
    var correct : String = "false"
    var hello = 1
}

class ProgressionTransform: ObservableObject {
    var timer = Timer()
    let engine = AudioEngine()
    let mic: AudioEngine.InputNode
    
    var tracker: PitchTap!
    let silence: Fader
    
    let frequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let notes_sharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let notes_flats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    var count : Int = 0
    
    var indexPlaying : Int = 0
    var flatNotes : [Int]  = []
    var sharpNotes : [Int] = []
    
    @Published var data = ProgressionTransformData()
    
    @objc func fireTimer() {
        if count == data.prog.steps.count - 1 {
            timer.invalidate()
        }
        data.prog_note = data.note_names[count]
        indexPlaying = count
        count += 1
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        data.pitch = pitch
        data.amplitude = amp

        var freq = pitch
        while freq > Float(frequencies[frequencies.count - 1]) {
            freq /= 2.0
        }
        while freq < Float(frequencies[0]) {
            freq *= 2.0
        }

        var min_dist: Float = 10_000.0
        var index = 0

        for i in 0 ..< frequencies.count {
            let dist = fabsf(Float(frequencies[i]) - freq)
            if dist < min_dist {
                index = i
                min_dist = dist
            }
        }
        
        let oct = Int(log2f(pitch / freq))
        print(index)
        data.note_sharps = "\(notes_sharps[index])\(oct)"
        data.note_flats = "\(notes_flats[index])\(oct)"
        
        if data.note_sharps == data.prog_note {
            data.correct = "True"
        }
        else {
            data.correct = "False"
            flatNotes.append(index)
        }
    }
    
    init() {
        guard let input = engine.input else {
            fatalError()
        }

        mic = input
        let node_1 = Fader(mic)
        let node_2 = Fader(node_1)
        let node_3 = Fader(node_2)
        let node_4 = Fader(node_3)
        let node_5 = Fader(node_4)
        let node_6 = Fader(node_5)
        silence = Fader(node_6, gain: 0)
        engine.output = silence
        
        data.prog_note = notes_sharps[data.start_note] + "\(data.start_oct)"
        data.intervals.append(0)
        data.note_names.append(data.prog_note)
        var temp = data.start_note
        for j in 0 ..< data.prog.steps.count - 1 {
            let a : Range<Double> = data.prog.steps[j].interval
            let i = Int(a.upperBound - a.lowerBound)
            temp += i
            data.intervals.append(i)
            let new_note = notes_sharps[temp]
            if new_note == "C" {
                data.start_oct += 1
            }
            data.note_names.append(new_note + "\(data.start_oct)")
        }

        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.update(pitch[0], amp[0])
            }
        }
    }
    
    func start() {
        do {
            try engine.start()
//            data.prog_note = notes_sharps[data.start_note] + "\(data.start_oct)"
//            data.note_names.append(data.prog_note)
//            var temp = data.start_note
//            for j in 0 ..< data.prog.steps.count {
//                let a : Range<Double> = data.prog.steps[j].interval
//                let i = Int(a.upperBound - a.lowerBound)
//                temp += i
//                let new_note = notes_sharps[temp]
//                if new_note == "C" {
//                    data.start_oct += 1
//                }
//                data.note_names.append(new_note + "\(data.start_oct)")
//            }
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            tracker.start()
        } catch let err {
            Log(err)
            }
    }

    func stop() {
        engine.stop()
        timer.invalidate()
    }
}

func mirrorProg(vals: inout Progression, notes: inout [String], intervals: inout [Int]) -> (notes: [String], vals: Progression, intervals: [Int]){
    let notes_len = notes.count
    let vals_len = vals.steps.count
    for i in 0 ..< notes_len {
        notes[i] = String(notes[i].dropLast())
    }
    for i in 2 ..< notes_len {
        notes.append(notes[notes_len - i])
        intervals.append(intervals[notes_len - i])
    }
    for j in 2 ..< vals_len {
        vals.steps.append(vals.steps[vals_len - j])
    }
    notes.append(notes[0])
    vals.steps.append(vals.steps[0])
    intervals.append(intervals[0])
    return (notes, vals, intervals)
}

struct ProgressionEvaluateView: View {
    @StateObject var transform = ProgressionTransform()
    var prog : Progression = load("pentatonic.json")
    @State var isClicked = false
    @State var longPress = false
    @State var indexPlaying = ProgressionTransform().indexPlaying
    @State var flatNotes = ProgressionTransform().flatNotes
    @State var sharpNotes = ProgressionTransform().sharpNotes
    
    
//    var notes : [String] = ProgressionTransform().data.note_names
//    var vals : Progression = ProgressionTransform().data.prog
    
    let result = mirrorProg(vals: &ProgressionTransform().data.prog, notes: &ProgressionTransform().data.note_names, intervals: &ProgressionTransform().data.intervals)
//    var notes : [String] = result.notes
//    var vals : Progression = result.vals
    
    var body: some View {
        VStack  {
            Spacer()
            HStack {
                StaffView(warmup: result.vals, notes: result.notes, intervals: result.intervals, indexPlaying: $transform.indexPlaying, flatNotes: $transform.flatNotes, sharpNotes: $transform.sharpNotes)
            }
            Text("\(transform.indexPlaying)")
//            HStack {
//                Text("\(transform.data.note_sharps)")
//                Spacer()
//                Text("\(transform.data.prog_note)")
//                Spacer()
//                Text("\(transform.data.correct)")
//            }
//            HStack {
//                Text("\(transform.data.start_note)")
//            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if self.longPress {
                        self.transform.start()
                        isClicked = false
                        longPress = false
                    }
                    self.transform.stop()
                }) {
                    Image(systemName: "arrow.down")
                
                }.foregroundColor(Color("downButton"))
                .padding()
                .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("downButton"), lineWidth: 2)
                        )
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                        self.transform.start()
                        isClicked = true
                        longPress = true
                    })
                )
                Spacer()
                Button(action: {
                    if self.longPress {
                        self.transform.start()
                        isClicked = false
                        longPress = false
                    }
                    self.transform.stop()
                }) {
                    Image(systemName: "mic")
                
                }.foregroundColor(Color("micButton"))
                .padding()
                .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("micButton"), lineWidth: 2)
                        )
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                        self.transform.start()
                        isClicked = true
                        longPress = true
                    })
                )
                Spacer()
                Button(action: {
                    if self.longPress {
                        self.transform.start()
                        isClicked = false
                        longPress = false
                    }
                    self.transform.stop()
                }) {
                    Image(systemName: "play.fill")
                
                }.foregroundColor(Color("playButton"))
                .padding()
                .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("playButton"), lineWidth: 2)
                        )
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                        self.transform.start()
                        isClicked = true
                        longPress = true
                    })
                )
                Spacer()
                Button(action: {
                    if self.longPress {
                        self.transform.start()
                        isClicked = false
                        longPress = false
                    }
                    self.transform.stop()
                }) {
                    Image(systemName: "arrow.up")
                
                }.foregroundColor(Color("upButton"))
                .padding()
                .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("upButton"), lineWidth: 2)
                        )
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                        self.transform.start()
                        isClicked = true
                        longPress = true
                    })
                )
                Spacer()
            }.padding()
            Spacer()
            HStack {
                Spacer()
                Text("It seems like you are singing slightly under pitch on some notes. Try to imagine your voice floating on top of the note instead of reaching up to it!")
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("playButton"), lineWidth: 2)
                )
                Spacer()
            }
            Spacer()
            Button(action: {
                if self.longPress {
                    self.transform.start()
                    isClicked = false
                    longPress = false
                }
                self.transform.stop()
            }) {
                Image(systemName: "questionmark")
            
            }.foregroundColor(Color("micButton"))
            .padding()
            .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color("micButton"), lineWidth: 2)
                    )
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                    self.transform.start()
                    isClicked = true
                    longPress = true
                })
            )
        }.navigationBarTitle(Text("Pentatonic Scale"))
//        .onAppear {
//            self.transform.start()
//        }
//        .onDisappear {
//            self.transform.stop()
//        }
    }
    
}
