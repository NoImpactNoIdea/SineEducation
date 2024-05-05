import SwiftUI
import Combine

struct DetailView: View {
    var data: SquareData
    
    @State private var sliderValue: Double
    @State private var isPlaying: Bool = false
    @StateObject private var sineWaveGenerator = SineWaveGenerator()

    private let resignActivePublisher = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)

    init(data: SquareData) {
        self.data = data
        _sliderValue = State(initialValue: data.hertz.0)
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
                    
                    Text("Adjust Sine Strength")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    Slider(value: $sliderValue, in: data.hertz.0...data.hertz.1, step: 1)
                        .onChange(of: sliderValue) { newValue in
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
            if isPlaying {
                sineWaveGenerator.stopTone()
                isPlaying = false
            }
        }
        .onDisappear {
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
            DetailView(data: SquareData(id: "dog", backgroundColor: .blue, imageName: "dog.fill", description: "Dogs have a sensitive range of hearing.", hertz: (20,20000)))
        }
    }
}
