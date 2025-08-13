//
//  Ex01ContentView.swift
//  Mobile42
//
//  Created by Joseph Lu on 8/5/25.
//

import SwiftUI

struct Ex01ContentView: View {
    @State private var showHello = true
    
    var body: some View {
        Text(showHello ? "Welcome to Ex01!" : "Hello World!")
        Button("Press me") {
            showHello.toggle()
            print("Button pressed - showHello is now: \(showHello)")
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

#Preview {
    Ex01ContentView()
}
