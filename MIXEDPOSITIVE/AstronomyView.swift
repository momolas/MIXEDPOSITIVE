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
            VStack(spacing: 20) {
                MoonPhaseView(phase: viewModel.moonPhase, fraction: viewModel.moonIlluminatedFraction)
                MoonTrendView(trend: viewModel.moonTrend)
                MoonTrajectoryView(direction: viewModel.moonDirection)

                MoonNodeView(
                    ascendingDate: viewModel.ascendingNodeDate,
                    descendingDate: viewModel.descendingNodeDate
                )

                MoonSignView(sign: viewModel.moonSign)
                GardeningView(element: viewModel.element)
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

private struct MoonPhaseView: View {
    let phase: String
    let fraction: Double

    var body: some View {
        VStack {
            Text("Phase de la lune")
                .font(.largeTitle)
            Text(phase)
            Text(fraction * 100, format: .number.precision(.fractionLength(0))) + Text("%")
        }
    }
}

private struct MoonTrendView: View {
    let trend: String

    var body: some View {
        VStack {
            Text("Tendance")
                .font(.largeTitle)
            Text(trend)
        }
    }
}

private struct MoonTrajectoryView: View {
    let direction: String

    var body: some View {
        VStack {
            Text("Trajectoire")
                .font(.largeTitle)
            Text(direction)
        }
    }
}

private struct MoonNodeView: View {
    let ascendingDate: String
    let descendingDate: String

    var body: some View {
        VStack(spacing: 10) {
            VStack {
                Text("Nœud ascendant")
                    .font(.largeTitle)
                Text(ascendingDate)
            }
            VStack {
                Text("Nœud descendant")
                    .font(.largeTitle)
                Text(descendingDate)
            }
        }
    }
}

private struct MoonSignView: View {
    let sign: String

    var body: some View {
        VStack {
            Text("Signe astrologique")
                .font(.largeTitle)
            Text(sign)
        }
    }
}

private struct GardeningView: View {
    let element: String

    var body: some View {
        VStack {
            Text("Jardinage")
                .font(.largeTitle)
            Text(element)
        }
    }
}

#Preview {
	AstronomyView()
		.environment(\.locale, Locale(identifier: "fr"))
		.preferredColorScheme(.dark)
}
