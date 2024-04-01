//
//  WrongResultView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/13.
//

import SwiftUI

struct WrongResultView: View {
    
    //@Binding var path : [resultpath]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack{
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 800, height: 200)
                    .position(x: geometry.size.width/2, y: geometry.size.height/5)
                
                VStack(alignment: .center){
                    
                    Text("Finger alphabets may be incorrest or not detected")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(Color.black)
                    
                    Text("Please review the following notes")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(Color.black)
                    
                }.position(x: geometry.size.width/2, y: geometry.size.height/5)
            }
            
            VStack(alignment: .leading, spacing: 50) { // VStackのalignmentを.leadingに設定
                
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.yellow)
                    
                    Text("Make Sure you are not wearing gloves or other gloves")
                        .fontWeight(.medium)
                        .font(.system(size: 30))
                        .foregroundColor(Color.black)
                    
                }
                
                HStack { // HStackのalignmentを.topに設定
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.yellow)
                    
                    Text("Make Sure all fingers are on the screen")
                        .fontWeight(.medium)
                        .font(.system(size: 30))
                        .foregroundColor(Color.black)
                    
                }
                
                HStack { // HStackのalignmentを.topに設定
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.yellow)
                    
                    Text("Make Sure you are not too far from the camera")
                        .fontWeight(.medium)
                        .font(.system(size: 30))
                        .foregroundColor(Color.black)
                    
                }
            }.position(x: geometry.size.width/2, y: geometry.size.height/2)
            
            
            Button(action: {
                
                dismiss()
                
            }, label: {
                
                Text("try again!!")
                    .bold()
                    .padding()
                    .frame(width: 210, height: 70)
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 3))
                
            }).position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/1.2))
        }
    }
}

