//
//  LsflearnView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

//プロトコルの定義
protocol LsfDismissHandlerDelegate {
    func lsfhandleDismiss()
}

//ページ数を保持する変数が格納されたクラス
class LsfPage: ObservableObject {
    @Published var Lsfcurrentpage:Int = 0
}

//実際に表示されるView
struct LsfleranViews: View {
    
    //Pageクラスのインスタンス生成
    @ObservedObject var lsfpage = LsfPage()
    
    @Binding var navigatePath: [SamplePath]
    
    @Binding var lsfisCheckedLeft: Bool
    @Binding var lsfisCheckedRight: Bool
    
    var body: some View {
        //ページ数に応じたViewを表示
        if lsfpage.Lsfcurrentpage == 0 && lsfisCheckedLeft == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "S", lsfimage: "SSL_S_L")
        }else if lsfpage.Lsfcurrentpage == 1 && lsfisCheckedLeft == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "W", lsfimage: "ASL_W")
        }else if lsfpage.Lsfcurrentpage == 2 && lsfisCheckedLeft == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "I", lsfimage: "ASL_I")
        }else if lsfpage.Lsfcurrentpage == 3 && lsfisCheckedLeft == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "F", lsfimage: "SSL_F")
        }else if lsfpage.Lsfcurrentpage == 4 && lsfisCheckedLeft == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "T", lsfimage: "SSL_T")
        }else if lsfpage.Lsfcurrentpage == 5 && lsfisCheckedLeft == true {
            LSFFinishView(navigatePath: $navigatePath)
        }
        
        if lsfpage.Lsfcurrentpage == 0 && lsfisCheckedRight == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "S", lsfimage: "SSL_S")
        }else if lsfpage.Lsfcurrentpage == 1 && lsfisCheckedRight == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "W", lsfimage: "ASL_W_L")
        }else if lsfpage.Lsfcurrentpage == 2 && lsfisCheckedRight == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "I", lsfimage: "ASL_I_L")
        }else if lsfpage.Lsfcurrentpage == 3 && lsfisCheckedRight == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "F", lsfimage: "SSL_F_L")
        }else if lsfpage.Lsfcurrentpage == 4 && lsfisCheckedRight == true {
            LSFlearnView(lsfpage: lsfpage, lsfalphabet: "T", lsfimage: "SSL_T_L")
        }else if lsfpage.Lsfcurrentpage == 5 && lsfisCheckedRight == true {
            LSFFinishView(navigatePath: $navigatePath)
        }
    }
}


//Viewを定義
struct LSFlearnView: View {
    
    //ProgressViewを管理する変数
    @State var lsfisPresentedProgressView = false
    
    // CslViewModelのインスタンス生成
    @StateObject private var lsfViewModel = LsfViewModel()
    
    //CorrectViewをモーダル表示するための変数
    @State private var lsfcorrectModal = false
    
    //WrongViewをモーダル表示するための変数
    @State private var lsfwrongModal = false
    
    //Pageクラスのインスタンスを共有する
    @ObservedObject var lsfpage: LsfPage
    
    //アルファベットを格納する変数
    var lsfalphabet: String
    
    //指文字の画像を格納する変数
    var lsfimage: String
    
    private func manageProgress(){
        //ProgressViewを表示する
        lsfisPresentedProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
            //3秒後に非表示にする
            self.lsfisPresentedProgressView = false
            
            //もし現在の指文字が、表示されているアルファベットと同じ場合は正解画面を表示する
            if
                lsfViewModel.lsfVisionClient.lsfcurrentGesture.rawValue == lsfalphabet {
                self.lsfcorrectModal = true
            } else {
                //不正解だった場合は、不正解画面を表示する
                self.lsfwrongModal.toggle()
            } 
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack{
                    Color.white
                        .ignoresSafeArea(.all)
                    
                    HStack(spacing: 45){
                        
                        Image(lsfimage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width/3.28, height: geometry.size.height/4.72)
                            .foregroundColor(.white)
                            .background(Color.blue)
                        
                        Image(systemName: "arrowtriangle.right.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width/8.2, height: geometry.size.height/11.8)
                            .foregroundColor(.black)
                        
                        Text(lsfalphabet)
                            .padding()
                            .font(.system(size: 250))
                            .frame(width: geometry.size.width/3.28, height: geometry.size.height/4.72)
                            .foregroundColor(.white)
                            .background(Color.blue)
                        
                    }.position(x:geometry.size.width/2, y: geometry.size.height/4.72)
                    
                    LsfCameraView(lsfcamera: lsfViewModel)
                        .frame(width: geometry.size.width/1.171, height: geometry.size.height/2.36)
                        .onAppear {
                            lsfViewModel.start()
                        }
                        .onDisappear {
                            lsfViewModel.stop()
                        }
                    
                    Button(action: manageProgress)
                    { Text("try it!")
                            .bold()
                            .padding()
                            .frame(width: 210, height: 70)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 3))
                        
                    }.position(CGPoint(x: geometry.size.width/2, y: 480))
                    
                    if lsfisPresentedProgressView {
                        
                        Color.gray.opacity(0.5)
                            .ignoresSafeArea(.all)
                        
                        VStack(spacing:0){
                            Text("Loading...")
                                .bold()
                                .padding()
                                .frame(width: 210, height: 70)
                                .foregroundColor(.black)
                            ProgressView()
                            
                        }.position(x:geometry.size.width/2, y:geometry.size.height/2)
                    }
                }
        }.fullScreenCover(isPresented: self.$lsfcorrectModal) { () -> LsfCorrectResultView in
            
            var lsfmodal = LsfCorrectResultView(isPresented: self.$lsfcorrectModal, lsfpage: lsfpage)
            lsfmodal.lsfdelegate = self
            return lsfmodal
            
        }
        .fullScreenCover(isPresented: self.$lsfwrongModal) {
            
            WrongResultView()
            
         }
       }
    }

struct LSFFinishView: View {
    @State private var lsfisShowingHomeView: Bool = false
    @Binding var navigatePath: [SamplePath]
    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                
                Text("Congratulations!!")
                    .font(.system(size: 80, weight: .semibold, design: .default))
                
                
                Spacer().frame(height: 170)
                
                Image(systemName: "swift")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.accentColor)
                
                HStack(spacing: 40){
                    
                    Text("S")
                        .font(.system(size: 100, weight: .semibold, design: .default))
                    Text("W")
                        .font(.system(size: 100, weight: .semibold, design: .default))
                    Text("I")
                        .font(.system(size: 100, weight: .semibold, design: .default))
                    Text("F")
                        .font(.system(size: 100, weight: .semibold, design: .default))
                    Text("T")
                        .font(.system(size: 100, weight: .semibold, design: .default))
                    
                }
                
                Button {
                    navigatePath.removeLast(navigatePath.count)
                } label: {
                    Text("Home")
                        .bold()
                        .padding()
                        .frame(width: 210, height: 70)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 3))
                }
            }.position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
    }
}


extension LSFlearnView : LsfDismissHandlerDelegate {
    func lsfhandleDismiss() {
        lsfpage.Lsfcurrentpage += 1
        print(lsfpage.Lsfcurrentpage)
    }
}

