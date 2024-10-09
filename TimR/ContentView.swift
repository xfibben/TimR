//
//  ContentView.swift
//  TimR
//
//  Created by Arturo Eyck Tapia Ramos on 9/10/24.
//
import SwiftUI

class Times: ObservableObject {
    @Published var time: TimeInterval = 0.0
    var timer: Timer?
    var startDate: Date?
    
    func startTime() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            if let startDate = self.startDate {
                self.time = Date().timeIntervalSince(startDate)
            }
        }
    }
    
    func stopTime() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView: View {
    @StateObject var times = Times()
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Start") {
                times.startTime()
            }
            Button("Stop") {
                times.stopTime()
            }
            Text("\(times.time, specifier: "%.3f") seconds")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

