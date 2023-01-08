//
//  ContentView.swift
//  Guess The Flag
//

import SwiftUI

struct ContentView: View
{
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany",
                                    "Ireland", "Italy", "Nigeria",
                                    "Poland", "Russia", "Spain",
                                    "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    let restartEvery = 5
    @State private var attempts = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }

        attempts += 1
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func continuePressed() {
        if attempts == restartEvery {
            showingFinalScore = true
        }
        else {
            askQuestion()
        }
    }
    
    func newGameTapped() {
        attempts = 0
        score = 0
        askQuestion()
    }
    
    var backgroundColors: [Color] {
        if colorScheme == .dark {
            return [Color(red: 0.05, green: 0.15, blue: 0.4), .black]
        } else {
            return [Color(red: 0.5, green: 1.0, blue: 0.9), .teal]
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: backgroundColors, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
            
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            
                    }
                    
                    ForEach(0..<3) {
                        number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                        }
                        .clipShape(Capsule(style: .continuous))
                        .shadow(radius: 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .padding(.horizontal, 25)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 7)
                
                Spacer()
                
                Text("Your score is \(score)")
                
                Spacer()
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: continuePressed)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game over", isPresented: $showingFinalScore) {
            Button("New game", action: newGameTapped)
        } message: {
            Text("Your score is \(score) out of \(restartEvery)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
