//
//  ContentView.swift
//  MIXEDPOSITIVE
//
//  Created by Mo on 15/02/2022.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [Color.blue.opacity(0.3), Color.black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    VStack(spacing: 10) {
                        Text("MIXEDPOSITIVE")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Votre assistant jardinage & astronomie")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.yellow)
                        .frame(width: 150, height: 150)
                        .shadow(color: .yellow.opacity(0.5), radius: 20, x: 0, y: 0)

                    Spacer()

                    NavigationLink(value: "Astronomy") {
                        Label("Commencer", systemImage: "sparkles")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 15))
                            .padding(.horizontal, 40)
                    }

                    Spacer()
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "Astronomy" {
                    AstronomyView()
                } else if value == "Calendar" {
                    CalendarGridView()
                }
            }
        }
    }
}

#Preview {
	LaunchView()
		.preferredColorScheme(.dark)
}
