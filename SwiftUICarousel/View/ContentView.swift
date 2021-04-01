//
//  ContentView.swift
//  SwiftUICarousel
//
//  Created by Simon Ng on 27/8/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isCardTapped = false
    @State private var currentTripIndex = 1
    
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { outerView in
            HStack(spacing: 0) {
                ForEach(sampleTrips.indices) { index in
                    GeometryReader { innerView in
                        TripCardView(destination: sampleTrips[index].destination, imageName: sampleTrips[index].image, isShowDetails: $isCardTapped)
                    }
                    .padding(.horizontal, isCardTapped ? 0 : 20)
                    .frame(width: outerView.size.width, height: outerView.size.height)  // 500)
                }
            }
            .offset(x: -CGFloat(currentTripIndex) * outerView.size.width)
            .offset(x: dragOffset)
            .gesture(
                !isCardTapped ?
                    DragGesture()
                    .updating($dragOffset, body: { (value, state, transaction) in
                        state = value.translation.width
                    })
                    .onEnded({ (value) in
                        /// Hvor stor del av bildet må jeg dra.
                        let threshold = outerView.size.width * 0.65
                        var newIndex = Int(-value.translation.width / threshold) + currentTripIndex
                        newIndex = min(max(newIndex, 0), sampleTrips.count - 1)
                        currentTripIndex = newIndex
                        print("currentTripIndex: \(currentTripIndex) \(dragOffset)")
                    })
                    : nil
            )
        }
//        .animation(.interpolatingSpring(mass: 0.6, stiffness: 100, damping: 10, initialVelocity: 0.3))
        .animation(.default)
    }
    
}
