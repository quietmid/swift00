//
//  ContentView.swift
//  Mobile42
//
//  Created by Joseph Lu on 8/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome to Ex00")
                .font(.title)
                .padding()
            
            Button("Press me") {
                print("Button pressed")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
}
