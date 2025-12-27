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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                MoonPhaseView(phase: viewModel.moonPhase, fraction: viewModel.moonIlluminatedFraction, icon: viewModel.moonPhaseIcon)
                    .modifier(CardStyle())

                MoonTrendView(trend: viewModel.moonTrend, icon: viewModel.moonTrendIcon)
                    .modifier(CardStyle())

                MoonTrajectoryView(direction: viewModel.moonDirection, icon: viewModel.moonDirectionIcon)
                    .modifier(CardStyle())

                MoonSignView(sign: viewModel.moonSign)
                    .modifier(CardStyle())

                GardeningView(element: viewModel.element, icon: viewModel.elementIcon)
                    .modifier(CardStyle())
            }
            .padding()

            // Nodes usually need more space or distinct layout
            MoonNodeView(
                ascendingDate: viewModel.ascendingNodeDate,
                descendingDate: viewModel.descendingNodeDate
            )
            .padding()
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 12))
            .padding(.horizontal)
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
            Text(fraction * 100, format: .number.precision(.fractionLength(0))) + Text("%")
                .font(.subheadline)
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

private struct MoonNodeView: View {
    let ascendingDate: String
    let descendingDate: String

    var body: some View {
        VStack(spacing: 12) {
            Text("Nœuds Lunaires")
                .font(.title2)
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "arrow.up.forward.circle")
                    VStack(alignment: .leading) {
                        Text("Nœud ascendant")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(ascendingDate)
                            .font(.body)
                    }
                }
                Divider()
                HStack {
                    Image(systemName: "arrow.down.forward.circle")
                    VStack(alignment: .leading) {
                        Text("Nœud descendant")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(descendingDate)
                            .font(.body)
                    }
                }
            }
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
