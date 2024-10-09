//
//  ContentView.swift
//  TimR
//
//  Created by Arturo Eyck Tapia Ramos on 9/10/24.
//

import SwiftUI

var time = 0

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Start") {
                time = 20
            }
            Text("\(time)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
