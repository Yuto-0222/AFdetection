//
//  ASLStartView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/13.
//

import SwiftUI

struct ASLStartView: View {
    
    @State private var isCheckedLeft = false
    @State private var isCheckedRight = false
    @Binding var navigatePath: [SamplePath]
    
    var body: some View {
        
        GeometryReader { geometry in
            
                VStack{
                    
                    Text("American Sign Language")
                        .font(.system(size: geometry.size.width/15, weight: .bold, design: .default))
                        .fontWeight(.heavy)
                    
                    Image("America")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width/2, height: geometry.size.height/2)
                    
                    VStack(spacing: 0){
                        Text("You can esaily learn American finger alphabet")
                            .font(.largeTitle)
                        
                        
                        Text("Please select your dominant hand")
                            .font(.largeTitle)
                    }
                    
                    HStack{
                        Spacer()
                        Toggle(isOn: $isCheckedLeft) {
                            Text("Left hand")
                             .font(.largeTitle)
                        }
                        .toggleStyle(.checkBox)
                        .disabled(isCheckedRight) 
                        
                        Spacer()
                        
                        Toggle(isOn: $isCheckedRight) {
                            Text("Right hand")
                             .font(.largeTitle)
                        }
                        .toggleStyle(.checkBox)
                        .disabled(isCheckedLeft)
                        Spacer()
                    }
                    
                    NavigationLink(destination: ASLleranViews(navigatePath: $navigatePath, isCheckedLeft: $isCheckedLeft, isCheckedRight: $isCheckedRight)) {
                        Text("Start learning")
                            .bold()
                            .padding()
                            .frame(width: 210, height: 70)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 3))
                               }
                    
                    /*NavigationLink{
                        
                        ASLlearnView()
                    
                    } label: {
                       
                    }*/
                    
                }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
            }
        }
    }

struct JSLStartView: View {
    
    @State private var jslisCheckedLeft = false
    @State private var jslisCheckedRight = false
    @Binding var navigatePath: [SamplePath]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack{
                
                Text("Japanese Sign Language")
                    .font(.system(size: geometry.size.width/15, weight: .bold, design: .default))
                    .fontWeight(.heavy)
                
                Image("Japan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width/2, height: geometry.size.height/2)
                VStack(spacing: 0){
                    Text("You can esaily learn Japanese finger alphabet")
                        .font(.largeTitle)
                    
                    Text("Please select your dominant hand")
                        .font(.largeTitle)
                }
                
                HStack{
                    Spacer()
                    Toggle(isOn: $jslisCheckedLeft) {
                        Text("Left hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(jslisCheckedRight) 
                    
                    Spacer()
                    
                    Toggle(isOn: $jslisCheckedRight) {
                        Text("Right hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(jslisCheckedLeft)
                    Spacer()
                }
                
                NavigationLink(destination: JslleranViews(navigatePath: $navigatePath, jslisCheckedLeft: $jslisCheckedLeft, jslisCheckedRight: $jslisCheckedRight)) {
                    Text("Start learning")
                        .bold()
                        .padding()
                        .frame(width: 210, height: 70)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3))
                }
                
            }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
        }
    }
}

struct CSLStartView: View {
    
    @State private var cslisCheckedLeft = false
    @State private var cslisCheckedRight = false
    @Binding var navigatePath: [SamplePath]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack{
                
                Text("Chinise Sign Language")
                    .font(.system(size: geometry.size.width/15, weight: .bold, design: .default))
                    .fontWeight(.heavy)
                
                Image("China")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width/2, height: geometry.size.height/2)
                VStack(spacing:0){
                    Text("You can esaily learn Chinese finger alphabet")
                        .font(.largeTitle)
                        .padding()
                    Text("Please select your dominant hand")
                        .font(.largeTitle)
                }
                
                HStack{
                    Spacer()
                    Toggle(isOn: $cslisCheckedLeft) {
                        Text("Left hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(cslisCheckedRight) 
                    
                    Spacer()
                    
                    Toggle(isOn: $cslisCheckedRight) {
                        Text("Right hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(cslisCheckedLeft)
                    Spacer()
                }
                
                NavigationLink(destination: CslleranViews(navigatePath: $navigatePath, cslisCheckedLeft: $cslisCheckedLeft, cslisCheckedRight: $cslisCheckedRight)) {
                    Text("Start learning")
                        .bold()
                        .padding()
                        .frame(width: 210, height: 70)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3))
                           }
                
            }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
        }
    }
}

struct LSFStartView: View {
    
    @State private var lsfisCheckedLeft = false
    @State private var lsfisCheckedRight = false
    @Binding var navigatePath: [SamplePath]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack{
                
                Text("Spain Sign Language")
                    .font(.system(size: geometry.size.width/15, weight: .bold, design: .default))
                    .fontWeight(.heavy)
                
                Image("Spain")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width/2, height: geometry.size.height/2)
                
                VStack(spacing:0){
                    Text("You can esaily learn Spanish finger alphabet")
                        .font(.largeTitle)
                    Text("Please select your dominant hand")
                        .font(.largeTitle)
                }
                
                HStack{
                    Spacer()
                    Toggle(isOn: $lsfisCheckedLeft) {
                        Text("Left hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(lsfisCheckedRight) 
                    
                    Spacer()
                    
                    Toggle(isOn: $lsfisCheckedRight) {
                        Text("Right hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(lsfisCheckedLeft)
                    Spacer()
                }
                
                NavigationLink(destination: LsfleranViews(navigatePath: $navigatePath, lsfisCheckedLeft: $lsfisCheckedLeft, lsfisCheckedRight: $lsfisCheckedRight)) {
                    Text("Start learning")
                        .bold()
                        .padding()
                        .frame(width: 210, height: 70)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3))
                }
                
            }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
        }
    }
}

struct LSMStartView: View {
    
    @State private var lsmisCheckedLeft = false
    @State private var lsmisCheckedRight = false
    @Binding var navigatePath: [SamplePath]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack{
                
                Text("Mexican Sign Language")
                    .font(.system(size: geometry.size.width/15, weight: .bold, design: .default))
                    .fontWeight(.heavy)
                
                Image("Mexico")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width/2, height: geometry.size.height/2)
                VStack(spacing:0){
                    Text("You can esaily learn Mexican finger alphabet")
                        .font(.largeTitle)
                    Text("Please select your dominant hand")
                        .font(.largeTitle)
                }
                
                HStack{
                    Spacer()
                    Toggle(isOn: $lsmisCheckedLeft) {
                        Text("Left hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(lsmisCheckedRight) 
                    
                    Spacer()
                    
                    Toggle(isOn: $lsmisCheckedRight) {
                        Text("Right hand")
                            .font(.largeTitle)
                    }
                    .toggleStyle(.checkBox)
                    .disabled(lsmisCheckedLeft)
                    Spacer()
                }
                
                NavigationLink(destination: LsmleranViews(navigatePath: $navigatePath, lsmisCheckedLeft: $lsmisCheckedLeft, lsmisCheckedRight: $lsmisCheckedRight)) {
                    Text("Start learning")
                        .bold()
                        .padding()
                        .frame(width: 210, height: 70)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3))
                }
                
            }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
        }
    }
}

public struct CheckBoxStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 50, height: 50) // トグルのサイズを設定
            }
            .foregroundStyle(configuration.isOn ? Color.accentColor : Color.primary)
            
            
            configuration.label
        }
    }
}

extension ToggleStyle where Self == CheckBoxStyle {
    public static var checkBox: CheckBoxStyle {
        .init()
    }
}
