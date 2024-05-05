import SwiftUI

struct DetailView: View {
    var data: SquareData
    
    @State private var sliderValue: Double
    @State private var isPlaying: Bool = false
    @StateObject private var sineWaveGenerator = SineWaveGenerator()
    
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
                            print(Int(newValue))
                            sineWaveGenerator.updateFrequency(frequency: newValue)
                        }
                        .onAppear {
                            sineWaveGenerator.updateFrequency(frequency: data.hertz.0)
                        }
                    
                    Button("Play Tone") {
                        sineWaveGenerator.startTone()
                        isPlaying = true
                    }
                    .disabled(isPlaying)
                    .opacity(1.0)
                    .padding(10)
                    .background(isPlaying ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    
                    Button("Stop Tone") {
                        sineWaveGenerator.stopTone()
                        isPlaying = false
                    }
                    .opacity(isPlaying ? 1.0 : 0.5)
                    .padding(10)
                    .background(Color.red)
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
        .onDisappear {
            if isPlaying {
                sineWaveGenerator.stopTone()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(data: SquareData(id: "dog", backgroundColor: .blue, imageName: "dog.fill", description: "Dogs have a sensitive range of hearing.", hertz: (20,20000)))
        }
    }
}
