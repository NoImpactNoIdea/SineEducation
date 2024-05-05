import Foundation
import AVFoundation

class SineWaveGenerator: ObservableObject {
    private var audioEngine: AVAudioEngine?
    private var toneNode: AVAudioSourceNode?
    private var isPlaying = false

    @Published var frequency: Double = 440
    
    func updateFrequency(frequency: Double) {
           self.frequency = frequency
    }

    func startTone() {
        if isPlaying { return }

        audioEngine = AVAudioEngine()
        toneNode = AVAudioSourceNode { _, _, frameCount, audioBufferList in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let theta_increment = 2.0 * Double.pi * self.frequency / (self.audioEngine?.outputNode.inputFormat(forBus: 0).sampleRate ?? 44100)

            var currentPhase = 0.0
            for frame in 0..<Int(frameCount) {
                let value = sin(currentPhase)
                currentPhase += theta_increment
                if currentPhase > 2.0 * Double.pi {
                    currentPhase -= 2.0 * Double.pi
                }
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = Float(value)
                }
            }
            return noErr
        }

        audioEngine?.attach(toneNode!)
        audioEngine?.connect(toneNode!, to: audioEngine!.outputNode, format: nil)

        do {
            try audioEngine?.start()
            isPlaying = true
        } catch {
            print("Could not start audio engine: \(error)")
        }
    }

    func stopTone() {
        if isPlaying {
            audioEngine?.stop()
            audioEngine = nil
            toneNode = nil
            isPlaying = false
        }
    }
}
