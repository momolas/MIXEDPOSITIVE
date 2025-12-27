//
//  AstronomyView.swift
//  MIXEDPOSITIVE
//
//  Created by Mo on 03/04/2023.
//

import SwiftUI

struct AstronomyView: View {
    @State private var viewModel = AstronomyViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                Button(action: {
                    NotificationManager.shared.requestPermission { granted in
                        if granted {
                            Task { @MainActor in
                                viewModel.scheduleNotifications()
                            }
                        }
                    }
                }) {
                    Image(systemName: "bell.badge")
                        .padding(8)
                        .background(.regularMaterial)
                        .clipShape(.circle)
                }
                
                Spacer()
                
                NavigationLink(value: "Calendar") {
                    Label("Calendrier", systemImage: "calendar")
                        .padding(8)
                        .background(.regularMaterial)
                        .clipShape(.capsule)
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                MoonPhaseView(phase: viewModel.moonPhase, fraction: viewModel.moonIlluminatedFraction, icon: viewModel.moonPhaseIcon)
                    .modifier(CardStyle())
                
                MoonTrendView(trend: viewModel.moonTrend, icon: viewModel.moonTrendIcon)
                    .modifier(CardStyle())
                
                MoonTrajectoryView(direction: viewModel.moonDirection, icon: viewModel.moonDirectionIcon)
                    .modifier(CardStyle())
                
                MoonSignView(sign: viewModel.moonSign)
                    .modifier(CardStyle())
                
                SunCardView(sunrise: viewModel.sunriseTime, sunset: viewModel.sunsetTime)
                    .modifier(CardStyle())
                
                GardeningView(element: viewModel.element, icon: viewModel.elementIcon)
                    .modifier(CardStyle())
                
                if !viewModel.plantsToPlant.isEmpty {
                    PlantGuideView(plants: viewModel.plantsToPlant)
                        .modifier(CardStyle())
                }
                
                NodeCardView(title: "Nœud ascendant", date: viewModel.ascendingNodeDate, icon: viewModel.ascendingNodeIcon, color: .teal)
                    .modifier(CardStyle())
                
                NodeCardView(title: "Nœud descendant", date: viewModel.descendingNodeDate, icon: viewModel.descendingNodeIcon, color: .pink)
                    .modifier(CardStyle())
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .background(Color(UIColor.systemGroupedBackground)) // Use standard grouped background
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 12))
    }
}

private struct MoonPhaseView: View {
    let phase: String
    let fraction: Double
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            Text("Phase")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(phase)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text("\(fraction * 100, format: .number.precision(.fractionLength(0)))%")
                .font(.subheadline)
        }
    }
}

private struct SunCardView: View {
    let sunrise: String
    let sunset: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "sun.max.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text("Soleil")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                VStack {
                    Image(systemName: "sunrise")
                        .font(.caption)
                    Text(sunrise)
                        .font(.subheadline)
                }
                VStack {
                    Image(systemName: "sunset")
                        .font(.caption)
                    Text(sunset)
                        .font(.subheadline)
                }
            }
        }
    }
}

private struct PlantGuideView: View {
    let plants: [String]
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "basket.fill")
                .font(.largeTitle)
                .foregroundStyle(.green)
            Text("À planter")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(plants.joined(separator: ", "))
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }
}

private struct MoonTrendView: View {
    let trend: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.blue)
            Text("Tendance")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(trend)
                .font(.headline)
        }
    }
}

private struct MoonTrajectoryView: View {
    let direction: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.purple)
            Text("Trajectoire")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(direction)
                .font(.headline)
        }
    }
}

private struct NodeCardView: View {
    let title: String
    let date: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(date)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }
}

private struct MoonSignView: View {
    let sign: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text("Signe")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(sign)
                .font(.headline)
        }
    }
}

private struct GardeningView: View {
    let element: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.green)
            Text("Jardinage")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(element)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
	AstronomyView()
		.environment(\.locale, Locale(identifier: "fr"))
		.preferredColorScheme(.dark)
}

