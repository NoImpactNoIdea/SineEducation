//
//  Home.swift
//  SineEducation
//
//  Created by Cristina Arcodia on 5/4/24.
//


import SwiftUI

// add sine frequency min and max
struct SquareData: Identifiable {
    var id: String
    var backgroundColor: Color
    var imageName: String
    var description: String
    var hertz: (Double, Double)
}
import SwiftUI

struct Home: View {
    private let animalStruct = [
        
        SquareData(id: "dog", backgroundColor: .blue, imageName: "dog.fill", description: "Your loyal canine companion boasts an incredible sense of hearing, far superior to your own. Dogs have a remarkable ability to detect frequencies ranging from 40 Hz to an impressive 60,000 Hz, compared to the human range of 20 Hz to 20,000 Hz. Their large, perked-up ears are finely tuned to capture a wide spectrum of sounds, from the faintest rustle of leaves to the distant echo of a far-off call. With such acute hearing, dogs excel at picking up on subtle auditory cues, making them invaluable companions in a variety of settings.", hertz: (15000, 20000)),
        
        SquareData(id: "cat", backgroundColor: .red, imageName: "cat.fill", description: "Your graceful feline friend is equipped with an extraordinary sense of hearing that rivals even the most finely tuned human ears. Cats can discern frequencies ranging from 45 Hz to an astounding 64,000 Hz, far surpassing the human auditory range. Their sleek, pointed ears are finely attuned to even the faintest of sounds, allowing them to effortlessly track the slightest movement or rustle. With their ability to detect high-pitched noises with remarkable precision, cats are natural-born hunters, able to stalk prey with unparalleled stealth.", hertz: (45, 24000)),
        
        SquareData(id: "bird", backgroundColor: .green, imageName: "bird.fill", description: "The avian world is filled with a symphony of sounds, and your feathered friends are finely attuned to every note. Birds possess an extraordinary sense of hearing, capable of detecting frequencies ranging from 50 Hz to 12,000 Hz, though this can vary depending on the species. Their keen ears are crucial for communication, navigation, and detecting potential threats in their environment. Whether it's the melodious trill of a songbird or the piercing cry of a raptor, birds rely on their acute hearing to interpret the world around them.", hertz: (50, 12000)),
        
        SquareData(id: "fish", backgroundColor: .orange, imageName: "fish.fill", description: "Beneath the surface of the water, a world of sound awaits, and your aquatic companions are more attuned to it than you might think. Fish have a unique way of perceiving sound, relying not on external ears but on specialized organs called otoliths, which detect vibrations in the water. While their hearing abilities vary depending on the species, many fish can detect frequencies ranging from 50 Hz to 3,000 Hz. From the gentle bubbling of a stream to the low rumble of distant thunder, fish use their sensitive hearing to navigate their watery habitats and communicate with one another.", hertz: (50, 3000)),
        
        SquareData(id: "rabbit", backgroundColor: .cyan, imageName: "hare.fill", description: "Your furry, long-eared companion may seem like a creature of quiet grace, but their hearing is finely tuned to the subtlest of sounds. Rabbits possess an acute sense of hearing, capable of detecting frequencies ranging from 360 Hz to 42,000 Hz. Their large, upright ears serve as sensitive antennas, swiveling and rotating to capture sounds from all directions. Whether it's the soft rustle of a predator in the underbrush or the distant call of a fellow rabbit, these sensitive ears play a crucial role in keeping your bunny friend alert and aware of their surroundings.", hertz: (360, 24000)),
        
        SquareData(id: "adult", backgroundColor: .purple, imageName: "figure", description: "As an adult human, your hearing is finely attuned to a specific range of frequencies, allowing you to navigate the auditory landscape of your environment with ease. The average adult can detect sounds within the range of 20 Hz to 20,000 Hz, encompassing a diverse array of pitches and tones. While your hearing may not rival that of your furry companions, it remains adept at discerning speech, music, and other essential auditory stimuli.", hertz: (20, 20000)),
        
        SquareData(id: "child", backgroundColor: .yellow, imageName: "figure.child", description: "As a yound child, developing ears are still honing their ability to perceive the rich tapestry of sounds in their surrounding. Children typically possess a hearing range similar to adults, spanning from 20 Hz to 20,000 Hz. However, their sensitivity to certain frequencies may vary as they grow and mature. During early childhood, their ears are particularly adept at picking up high-pitched sounds, gradually expanding to encompass a wider range of frequencies as they age.", hertz: (20, 20000)),
        
        SquareData(id: "lizard", backgroundColor: .mint, imageName: "lizard.fill", description: "Stealthy and often unseen, lizards navigate their world with a keen sense of hearing attuned to the subtleties of their environment. Lizards can typically hear frequencies ranging from about 100 Hz to 5,000 Hz, with some species sensitive to even higher frequencies. This auditory range allows them to detect the movements of prey and predators alike, as well as communicate with other lizards through subtle sounds and vibrations. Their ears, usually not visible externally, are finely adapted to pick up on these crucial sounds that play a vital role in their survival and social interactions. From the soft skitter of an insect to the warning rustle of leaves disturbed by a larger creature, lizards rely on their hearing to stay one step ahead in the diverse habitats they occupy.", hertz: (100, 5000)),
    ]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width / 2.5
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerText
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(animalStruct) { square in
                            NavigationLink(destination: DetailView(data: square)) {
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
    }
    
    var headerText: some View {
        VStack(alignment: .leading) {
            Text("Sine Education")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
            Text("Learn More About Animals")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.bottom, 30)
        }
        .multilineTextAlignment(.leading)
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
