//
//  DetailView.swift
//  SineEducation
//
//  Created by Charlie Arcodia on 5/4/24.


import SwiftUI
import Combine

struct DetailView: View {
    var data: SquareData
    
    @State private var sliderValue: Double
    @State private var isPlaying: Bool = false
    @StateObject private var sineWaveGenerator: SineWaveGenerator

    private let resignActivePublisher = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)

    init(data: SquareData, selectedWaveform: Waveform) {
        self.data = data
        _sliderValue = State(initialValue: data.hertz.0)
        _sineWaveGenerator = StateObject(wrappedValue: SineWaveGenerator(waveform: selectedWaveform))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                Color(data.backgroundColor)
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                    .overlay(
                        Image(systemName: data.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    )
                    .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Adjust Frequency Strength")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    Text("Waveform: ")
                        .font(.headline)
                    + Text(self.sineWaveGenerator.waveform.rawValue.localizedCapitalized)
                        .font(.headline)
                        .foregroundColor(self.data.backgroundColor)
                    
                    Slider(value: $sliderValue, in: data.hertz.0...data.hertz.1, step: 1)
                        .onChange(of: sliderValue) { newValue, _ in
                            if isPlaying {
                                sineWaveGenerator.updateFrequency(frequency: newValue)
                            }
                        }
                        .onAppear {
                            sineWaveGenerator.updateFrequency(frequency: data.hertz.0)
                        }
                    
                    Button(isPlaying ? "Stop Tone" : "Play Tone") {
                        togglePlay()
                    }
                    .padding(10)
                    .background(isPlaying ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    
                    Text("\(Int(sliderValue)) Hz")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(data.id.capitalized)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                    
                    Text(data.description)
                        .font(.body)
                        .padding(.top, 0)
                    
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea()
        }
        .navigationTitle(data.id.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(resignActivePublisher) { _ in
            print("Is this called at all?")
            if isPlaying {
                sineWaveGenerator.stopTone()
                isPlaying = false
            }
        }
        .onDisappear {
            print("Is this called at all also?")

            if isPlaying {
                sineWaveGenerator.stopTone()
            }
        }
    }

    private func togglePlay() {
        if isPlaying {
            sineWaveGenerator.stopTone()
        } else {
            sineWaveGenerator.startTone()
            sineWaveGenerator.updateFrequency(frequency: sliderValue)
        }
        isPlaying.toggle()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(data: SquareData(id: "dog", backgroundColor: .blue, imageName: "dog.fill", description: "Dogs have a sensitive range of hearing.", hertz: (20,20000)), selectedWaveform: .sine)
        }
    }
}
