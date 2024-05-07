//
//  Home.swift
//  SineEducation
//
//  Created by Charlie Arcodia on 5/4/24.


struct SquareData: Identifiable {
    var id: String
    var backgroundColor: Color
    var imageName: String
    var description: String
    var hertz: (Double, Double)
}

enum Waveform: String, CaseIterable, Identifiable {
    case sine, square, triangle, sawtooth
    
    var id: String { self.rawValue }
}

import SwiftUI

struct Home: View {
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var showingFrequencyPopup = false
    @State public var selectedWaveform: Waveform = .sine
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width / 2.5
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerText
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(animalStruct) { square in
                            
                            NavigationLink(destination: DetailView(data: square, selectedWaveform: selectedWaveform)) {
                                gridSquare(square, screenWidth: screenWidth)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color("MainBackground", bundle: .main).ignoresSafeArea())
        }
        .sheet(isPresented: $showingFrequencyPopup) {
            FrequencySelectionView(selectedWaveform: $selectedWaveform) {
                showingFrequencyPopup = false
            }
        }
        .background(Color("MainBackground", bundle: .main))
    }
    
    var headerText: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Shawave")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                Text("Discover Nature's Symphony")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
            }
            Spacer()
            Button(action: {
                showingFrequencyPopup = true
            }) {
                Image(systemName: "waveform.badge.plus")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding(.trailing, 30)
        }
        .padding(.leading, 30)
    }
    
    func gridSquare(_ square: SquareData, screenWidth: CGFloat) -> some View {
        Rectangle()
            .fill(square.backgroundColor)
            .frame(width: screenWidth, height: screenWidth)
            .cornerRadius(10)
            .overlay(
                Image(systemName: square.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth / 2)
            )
    }
}

struct FrequencySelectionView: View {
    @Binding var selectedWaveform: Waveform
    var onSelectionDone: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    onSelectionDone()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            Spacer()
            
            Text("Select Waveform Type")
                .font(.headline)
                .padding(.vertical)
            
            Picker("Waveform", selection: $selectedWaveform) {
                ForEach(Waveform.allCases) { waveform in
                    Text(waveform.rawValue.capitalized).tag(waveform)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedWaveform) {
                onSelectionDone()
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
