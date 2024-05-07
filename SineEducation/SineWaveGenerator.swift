//
//  SineWaveGenerator.swift
//  SineEducation
//
//  Created by Charlie Arcodia on 5/4/24.


import Foundation
import AVFoundation

class SineWaveGenerator: ObservableObject {
    private var audioEngine: AVAudioEngine
    private var toneNode: AVAudioSourceNode?
    private var currentPhase: Double = 0.0
    private var thetaIncrement: Double = 0.0
    private var sampleRate: Double = 44100.0
    @Published var waveform: Waveform
    
    @Published var frequency: Double = 440 {
        didSet {
            updateThetaIncrement()
        }
    }
    
    init(waveform: Waveform) {
           self.waveform = waveform
           audioEngine = AVAudioEngine()
           configureToneNode()
           setupAudioEngine()
       }
    
    private func configureToneNode() {
        toneNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let value: Float = {
                    switch self.waveform {
                    case .sine:
                        return Float(sin(self.currentPhase))
                    case .square:
                        return self.currentPhase < .pi ? 1.0 : -1.0
                    case .triangle:
                        return Float(-1 + (2 / .pi) * self.currentPhase)
                    case .sawtooth:
                        return Float((2 / .pi) * (self.currentPhase - .pi))
                    }
                }()
                self.currentPhase += self.thetaIncrement
                if self.currentPhase > 2.0 * .pi {
                    self.currentPhase -= 2.0 * .pi
                }
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = value
                }
            }
            return noErr
        }
    }
    
    private func setupAudioEngine() {
        sampleRate = audioEngine.outputNode.inputFormat(forBus: 0).sampleRate
        
        if let node = self.toneNode {
            audioEngine.attach(node)
            audioEngine.connect(node, to: audioEngine.outputNode, format: nil)
        }
       
        updateThetaIncrement()
    }

    private func updateThetaIncrement() {
        thetaIncrement = 2.0 * Double.pi * frequency / sampleRate
    }
    
    func updateFrequency(frequency: Double) {
        self.frequency = frequency
    }
    
    func startTone() {
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
            } catch {
                print("Error starting audio engine: \(error)")
            }
        }
    }
    
    func stopTone() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    deinit {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
    }
}
