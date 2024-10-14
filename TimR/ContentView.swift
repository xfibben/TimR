//
//  ContentView.swift
//  TimR
//
//  Created by Arturo Eyck Tapia Ramos on 9/10/24.
//
import SwiftUI
import AVFoundation
import AppKit



class TimerModel: ObservableObject {
    @Published var timeRemaining: TimeInterval = 0.0
    @Published var isRunning = false
    @Published var totalDuration: TimeInterval = 0.0
    var timer: Timer?
    var alarmPlayer: AVAudioPlayer?

    
    func startTimer(duration: TimeInterval) {
        totalDuration = duration
        timeRemaining = duration
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tick()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func cancelTimer() {
        stopTimer()
        timeRemaining = 0.0
    }
    
    func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            stopTimer()
            playAlarm()
        }
    }
    
    func playAlarm() {
        if let sound = NSSound(named: NSSound.Name("Sosumi")) {
            for i in 0 ... 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.0) {
                    sound.play()
                }
            }
        } else {
            print("Sound not found")
        }
    }


    
    func progress() -> Double {
        return totalDuration > 0 ? timeRemaining / totalDuration : 0
    }
}

struct ContentView: View {
    @StateObject var timerModel = TimerModel()
    @State private var customTime = 0.0 // Custom time input
    
    var body: some View {
        VStack {
            // Barra de progreso
            ProgressView(value: timerModel.progress())
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
            
            // Botones de tiempo predeterminado
            HStack {
                Button("3 Min") {
                    timerModel.startTimer(duration: 3 * 60)
                }
                Button("5 Min") {
                    timerModel.startTimer(duration: 5 * 60)
                }
                Button("10 Min") {
                    timerModel.startTimer(duration: 10 * 60)
                }
                Button("20 Min") {
                    timerModel.startTimer(duration: 10 * 60)
                }
            }
            .padding()
            
            // Entrada personalizada del temporizador
            HStack {
                Text("Set Time:")
                TextField("00:00", value: $customTime, formatter: timeFormatter)
                    .frame(width: 60)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("min")
            }
            .padding()
            
            // Botón de inicio/stop y cancelar
            HStack {
                Button(timerModel.isRunning ? "Stop" : "Start") {
                    if timerModel.isRunning {
                        timerModel.stopTimer()
                    } else {
                        timerModel.startTimer(duration: customTime * 60)
                    }
                }
                .padding()
                
                if timerModel.isRunning {
                    Button("Cancel") {
                        timerModel.cancelTimer()
                    }
                    .padding()
                }
            }
            
            // Mostrar tiempo restante
            Text(timeString(from: timerModel.timeRemaining))
                .font(.system(size: 40))
                .padding()
        }
        .padding()
        .frame(width: 400, height: 300)
    }
    
    // Formateador de tiempo personalizado
    var timeFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // Convertir segundos a formato mm:ss
    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}



//#Preview {
//    ContentView()
//}

