//
//  ContentView.swift
//  calaculator
//
//  Created by HGNIS on 07/04/22.
//

import SwiftUI
import AVFoundation


import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
    
    static let lightStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let lightEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                            )
                    } else {
                        Circle()
                            .fill(Color.offWhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
            .animation(nil)
    }
}

struct DarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            DarkBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct ColorfulButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                ColorfulBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
            .animation(nil)
    }
}

struct ColorfulToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            ColorfulBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct ContentView: View {
    
    @State private var isToggled = false
    let generator = UINotificationFeedbackGenerator()
    @State private var textData: String = "0"
    
    private var textSize:Double=40
    
    var body: some View {
        ZStack{
            LinearGradient(Color.darkStart, Color.darkEnd)
            VStack(alignment: .trailing) {
                Text(textData)
                    .frame(maxHeight: .infinity)
                    .multilineTextAlignment(.trailing)
                
                    .foregroundColor(.white)
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.1)
                
                HStack {
                    Button(action: {
                        vibrateAndSound()
                        textData="0"
                        //sendToCalculate(value: "C")
                    }) {
                        Image("c")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }
                    .buttonStyle(ColorfulButtonStyle()).padding(30)
                    
                    Spacer()
                    Button {
                        sendToCalculate(value: "#")
                        
                    } label: {
                        Image("plus_minus")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "%")
                    } label: {
                        Image("percent")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "/")
                    } label: {
                        Image("devide")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                }
                Spacer()
                HStack {
                    Button {
                        sendToCalculate(value: "7")
                    } label: {
                        Image("seven")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "8")
                    } label: {
                        Image("eight")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "9")
                    } label: {
                        Image("nine")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "*")
                    } label: {
                        Image("multiply")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                }
                Spacer()
                HStack {
                    Button {
                        sendToCalculate(value: "4")
                        
                    } label: {
                        Image("four")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "5")
                    } label: {
                        Image("five")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "6")
                    } label: {
                        Image("six")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).font(.system(size: 45, weight: .bold, design: .default)).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "-")
                    } label: {
                        Image("minus")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }.buttonStyle(ColorfulButtonStyle()).font(.system(size: 45, weight: .bold, design: .default)).padding(30)
                }
                Spacer()
                HStack {
                    Button {
                        sendToCalculate(value: "1")
                    } label: {
                        Image("one")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    
                    Spacer()
                    
                    Button {
                        sendToCalculate(value: "2")
                    } label: {
                        Image("two")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                        
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "3")
                    } label: {
                        Image("three")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "+")
                    } label: {
                        Image("plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    
                }
                
                Spacer()
                HStack {
                    
                    Button {
                        sendToCalculate(value: "0")
                    } label: {
                        Image("zero")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: ".")
                    } label: {
                        Image("dot")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(20)
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    
                    Spacer()
                    Button {
                        sendToCalculate(value: ".")
                    } label: {
                        Image("dot")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(20)
                    }.buttonStyle(ColorfulButtonStyle()).padding(30)
                    Spacer()
                    Button {
                        sendToCalculate(value: "=")
                    } label: {
                        Image("equal")
                            .resizable()
                            .aspectRatio(contentMode: .fit).padding(0)
                    }.buttonStyle(ColorfulButtonStyle()).font(.system(size: 45, weight: .bold, design: .default)).padding(30)
                }
                
            }.padding(15)
        }.background( LinearGradient(Color.darkStart, Color.darkEnd)).ignoresSafeArea(.keyboard)
    }
    func  sendToCalculate(value:String){
        vibrateAndSound()
        calculate(value: value)
        if(textData.hasPrefix("0")){
            textData.remove(at: textData.startIndex)
        }
        
    }
    func vibrateAndSound(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
    func calculate(value:String){
        print(textData)
        switch(value){
        case "%":
            if(!textData.isEmpty){
                let data=Float(textData)!/100
                textData=String(data)
            }
        case ".":
            if(!textData.hasSuffix(".")){
                textData=textData.appending(value)
            }
        case "/":
            if (chechForOperator()){
            if(!textData.hasSuffix("/")){
                textData=textData.appending(value)
            } }else{
                textData=textData.appending("0")
            }
        case "*":
            if (chechForOperator()){
            if(!textData.hasSuffix("*")){
                textData=textData.appending(value)
            } }else{
                textData=textData.appending("0")
            }
        case "-":
            if (chechForOperator()){
            if(!textData.hasSuffix("-")){
                textData=textData.appending(value)
            }
        }else{
            textData=textData.appending("0")
        }
        case "+":
            if (chechForOperator()){
            if(!textData.hasSuffix("+")){
                textData=textData.appending(value)
            }
                
            }else{
                textData=textData.appending("0")
            }
        case "=":
            
            calcalteTheExpression()
        case "#":
            print(textData.startIndex)
            if(textData.hasPrefix("-")){
                textData.remove(at: textData.startIndex)
                textData.insert("+", at: textData.startIndex)
            }else{textData.remove(at: textData.startIndex)
                textData.insert("-", at: textData.startIndex)
            }
            
        default:
            textData=textData.appending(value)
        }
        
    }
    func chechForOperator() -> Bool{
       
        if(textData == "0" && textData.count==1){
            return false
        }else{
            return true
        }
    }
    
    func calcalteTheExpression(){
        //textData=Float(textData)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
