//
//  FourierTransforms.swift
//  SeniorComps
//
//  Created by Hilary on 9/17/21.
//

import Foundation
import AudioKitEX
import AudioKit
import UIKit
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

struct TransformData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var note_sharps = " "
    var note_flats = " "
}

class Transform: ObservableObject {
    
    let engine = AudioEngine()
    let mic: AudioEngine.InputNode
    
    var tracker: PitchTap!
    let silence: Fader
    
    let frequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let notes_sharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let notes_flats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    @Published var data = TransformData()
    
    var indexes: [Int] = []
    
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
        indexes.append(index)
        let size = Double(indexes.count)
        var ind =  0.0
        if size == 50 {
            indexes.remove(at: 0)
            let total = Double(indexes.reduce(0, +))
            print(total)
            ind = total / 50
            print(index)
        }
        else {
            let total = Double(indexes.reduce(0, +))
            print(total)
            ind = total/size
        }
        if (ind.truncatingRemainder(dividingBy: 1) >= 0.5) {
            index = Int((ind / 1) + 1)
        }
        else {
            index = Int(ind / 1 )
        }
        let oct = Int(log2f(pitch / freq))
        print(index)
        data.note_sharps = "\(notes_sharps[index])\(oct)"
        data.note_flats = "\(notes_flats[index])\(oct)"
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

        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                FIXME
                self.update(pitch[0], amp[0])
            }
        }
    }

    func start() {
        do {
            try engine.start()
            tracker.start()
        } catch let err {
            Log(err)
            }
    }

    func stop() {
        engine.stop()
    }
    
}

struct TunerView: View {
    @StateObject var transform = Transform()
    @State private var showDevices: Bool = false
    @State var isClicked = false
    @State var longPress = false

    var body: some View {
        VStack {
            HStack {
                Text("Note Name")
                Spacer()
                Text("\(transform.data.note_sharps) / \(transform.data.note_flats)")
            }.padding()
            Button(action: {
                if self.longPress {
                    self.transform.start()
                    isClicked = false
                    longPress = false
                }
                self.transform.stop()
            }) {
                Image(systemName: "mic")
            
            }.simultaneousGesture(
                LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                    self.transform.start()
                    isClicked = true
                    longPress = true
                })
            )}
    }
}

struct MySheet: View {
    @Environment(\.presentationMode) var presentationMode
    var transform: Transform

    func getDevices() -> [Device] {
        return AudioEngine.inputDevices.compactMap { $0 }
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ForEach(getDevices(), id: \.self) { device in
                Text(device == self.transform.engine.inputDevice ? "* \(device.deviceID)" : "\(device.deviceID)").onTapGesture {
                    do {
                        try AudioEngine.setInputDevice(device)
                    } catch let err {
                        print(err)
                    }
                }
            }
            Text("Dismiss")
                .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
