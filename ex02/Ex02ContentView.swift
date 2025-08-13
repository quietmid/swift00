//
//  Ex02ContentView.swift
//  Mobile42
//
//  Created by Joseph Lu on 8/5/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif


struct Ex02ContentView: View {
    #if os(iOS)
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    #endif
    let grid = [
        ["AC", "C", "+/-", "/"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        [" ", "0", ".", "="]
    ]
    
    let operators = ["/", "+", "X"]
    
    @State var visibleWorking = ""
    @State var visibleResult = ""
    @State var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text(visibleWorking)
                        .padding()
                        .foregroundColor(Color.white)
                        .font(.system(size: 30, weight: .heavy))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    Spacer()
                    Text(visibleResult)
                        .padding()
                        .foregroundColor(Color.white)
                        .font(.system(size: 50, weight: .heavy))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                ForEach(grid, id: \.self) {
                    row in
                    HStack {
                        ForEach(row, id: \.self) {
                            cell in
                            
                            Button(action: { buttonPressed(cell: cell)}, label: {
                                Text(cell)
                                    .foregroundColor(buttonColor(cell))
                                    .font(.system(size: 40, weight: .heavy))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            })
                        }
                    }
                }
            }
            .navigationTitle("Calculator")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalide Input"),
                    message: Text(visibleWorking),
                    dismissButton: .default(Text("OK"))
                )
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .background(Color.black.ignoresSafeArea())
        }
    }
    
    func buttonColor(_ cell: String) -> Color {
        if (cell == "AC" || cell == "C") {
            return .red
        }
        if (cell == "+/-") {
            return .yellow
        }
        if (cell == "-" || cell == "=" || operators.contains(cell)) {
            return .orange
        }
        return .white
    }
        
    func buttonPressed(cell: String) {
        print("Button pressed: \(cell)")
        
        switch (cell) {
        case "AC":
            visibleWorking = ""
            visibleResult = ""
        case "C":
            visibleWorking = String(visibleWorking.dropLast())
        case "=":
            visibleResult = calculateResults()
        case "+/-":
            print("negative pressed")
            turnNegative()
        case "-":
            addMinus()
        case "X", "/", "+":
            addOperator(cell)
        default:
            visibleWorking += cell
        }
    }
    // Turn negative not working, it is not entering the case but the other functions of a basic calculator seems to be working
    func turnNegative() {
        print("here")
        if (!visibleWorking.isEmpty) {
            let operatorSet: Set<Character> = ["+", "X", "/"]
            var lastOpIndex: String.Index? = nil
            
            // Find the last operator in the string (excluding minus)
            for i in visibleWorking.indices.reversed() {
                if operatorSet.contains(visibleWorking[i]) {
                    lastOpIndex = i
                    print("at \(i)")
                    break
                }
            }
            // Get the starting index of the current number
            let numberStartIndex = lastOpIndex.map { visibleWorking.index(after: $0) } ?? visibleWorking.startIndex
            let numberPart = String(visibleWorking[numberStartIndex...])
            
            // Only proceed if we have a number part
            if !numberPart.isEmpty {
                var newNumberPart: String
                
                // Toggle logic - make negative or positive
                if numberPart.hasPrefix("-") {
                    // Remove the minus to make it positive
                    newNumberPart = String(numberPart.dropFirst())
                } else {
                    // Add minus to make it negative
                    newNumberPart = "-" + numberPart
                }
                
                // Replace in visibleWorking
                let prefixPart = String(visibleWorking[..<numberStartIndex])
                visibleWorking = prefixPart + newNumberPart
            }
        }
    }
    
    func addOperator(_ cell : String) {
        if (!visibleWorking.isEmpty) {
                let last = String(visibleWorking.last!)
            if (operators.contains(last)) {
                visibleWorking.removeLast()
            }
            visibleWorking += cell
        }
    }
    
    func addMinus() {
        if (visibleWorking.isEmpty || visibleWorking.last! != "-") {
                visibleWorking += "-"
        }
    }
    
    func calculateResults() -> String {
        if (validInput()) {
            let workings = visibleWorking.replacingOccurrences(of: "X", with: "*")
            let expression = NSExpression(format: workings)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            return formatResult(val: result)
//            return result
        }
        showAlert = true
        return ""
    }
    
    func validInput() -> Bool {
        if (visibleWorking.isEmpty){
            return false
        }
        let last = String(visibleWorking.last!)
        
        if (operators.contains(last) || last == "-") {
            if (visibleWorking.count == 1) {
                return false
            }
        }
        return true
    }
    //check if the value is an integer or not, if it's not, if will return up to 2 digit after .
    func formatResult(val : Double) -> String {
        if(val.truncatingRemainder(dividingBy: 1) == 0) {
            return String(format: "%.0f", val)
        }
        
        return String(format: "%.2f", val)
    }
}

#Preview {
    Ex02ContentView()
}

