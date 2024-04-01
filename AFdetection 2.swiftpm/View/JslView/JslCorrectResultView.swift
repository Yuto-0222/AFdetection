//
//  JslCorrectResultView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

struct JslCorrectResultView: View {
    
    //@State var currentalphabet: Int = 0
    //@Binding var path :[resultpath]
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var jslpage: JslPage
    
    var jsldelegate: JslDismissHandlerDelegate?
    
    @Binding var jslcorrectModal: Bool
    
    init(isPresented: Binding<Bool>, jslpage: JslPage) {
            self._jslcorrectModal = isPresented
            self.jslpage = jslpage
        }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            HStack(spacing: 50){
                
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("Great job!!")
                    .font(.system(size: 80, weight: .semibold, design: .default))
                
            }.position(x: geometry.size.width/2, y: geometry.size.height/4.48)
            
            ZStack {
                Circle()
                    .stroke(
                        Color.gray,
                        style: StrokeStyle(
                            lineWidth: 15,
                            lineCap: .round)
                    )
                    .opacity(0.5)
                    .frame(width: 300, height: 300)
                if jslpage.Jslcurrentpage == 0{
                    Circle()
                        .trim(from: 0.0, to: 0.2)
                        .stroke(
                            Color.green,
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round)
                        )
                        .frame(width: 300, height: 300)
                        .rotationEffect(Angle(degrees: -90))// 追加
                } else if jslpage.Jslcurrentpage == 1 {
                    Circle()
                        .trim(from: 0.0, to: 0.4)
                        .stroke(
                            Color.green,
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round)
                        )
                        .frame(width: 300, height: 300)
                        .rotationEffect(Angle(degrees: -90))// 追加
                } else if jslpage.Jslcurrentpage == 2 {
                    Circle()
                        .trim(from: 0.0, to: 0.6)
                        .stroke(
                            Color.green,
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round)
                        )
                        .frame(width: 300, height: 300)
                        .rotationEffect(Angle(degrees: -90))// 追加
                } else if jslpage.Jslcurrentpage == 3 {
                    Circle()
                        .trim(from: 0.0, to: 0.8)
                        .stroke(
                            Color.green,
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round)
                        )
                        .frame(width: 300, height: 300)
                        .rotationEffect(Angle(degrees: -90))// 追加
                } else if jslpage.Jslcurrentpage == 4 {
                    Circle()
                        .trim(from: 0.0, to: 1.0)
                        .stroke(
                            Color.green,
                            style: StrokeStyle(
                                lineWidth: 15,
                                lineCap: .round)
                        )
                        .frame(width: 300, height: 300)
                        .rotationEffect(Angle(degrees: -90))// 追加
                }
                
                Image(systemName: "swift")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.accentColor)
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
            
            HStack(spacing: 20){
                
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 130, height: 130)
                    
                    Text("S")
                        .font(.system(size: 80, weight: .semibold, design: .default))
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 130, height: 130)
                    
                    if jslpage.Jslcurrentpage >= 1 {
                        
                        Text("W")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                    } else {
                        Text("W")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                            .opacity(0.1)
                    }
                    
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 130, height: 130)
                    if jslpage.Jslcurrentpage >= 2 {
                        
                        Text("I")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                    } else {
                        Text("I")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                            .opacity(0.1)
                    }
                    
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 130, height: 130)
                    if jslpage.Jslcurrentpage >= 3 {
                        
                        Text("F")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                    } else {
                        Text("F")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                            .opacity(0.1)
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 130, height: 130)
                    if jslpage.Jslcurrentpage >= 4 {
                        
                        Text("T")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                    } else {
                        Text("T")
                            .font(.system(size: 80, weight: .semibold, design: .default))
                            .opacity(0.1)
                    }
                }
                Spacer()
            }.position(x:geometry.size.width/2, y:geometry.size.height/1.3)
            
            Button(action: {
                
                self.jslcorrectModal = false
                //print(page.Aslcurrentpage)
                
            }, label: {
                if jslpage.Jslcurrentpage == 4 {
                    
                    Text("Finish!")
                        .bold()
                        .padding()
                        .frame(width: 210, height: 70)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3))
                    
                } else {
                    
                    Text("next!!")
                        .bold()
                        .padding()
                        .frame(width: 210, height: 70)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3))
                }
            }).position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/1.1))
        }.onDisappear { self.jsldelegate?.jslhandleDismiss()}
    }
}
