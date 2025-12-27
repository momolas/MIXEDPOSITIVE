//
//  ContentView.swift
//  MIXEDPOSITIVE
//
//  Created by Mo on 15/02/2022.
//

import SwiftUI
import SwiftAA

struct LaunchView: View {
	var body: some View {
		NavigationStack {
			VStack {
				
				Spacer()
				
				Text("MIXEDPOSITIVE")
					.font(.largeTitle)
				
				Text("Une application pour faire des calculs astronomiques")
					.font(.caption)
				
				Spacer()
				
                NavigationLink(destination: ContentView(), label: { Image(systemName: "moon.stars")
						.renderingMode(.original)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.foregroundColor(.green)
						.frame(width: 200, height: 200)
				})
				
				Spacer()
				Spacer()
			}
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

#Preview {
	LaunchView()
		.preferredColorScheme(.dark)
}
