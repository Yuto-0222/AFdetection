//
//  JsllearnView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

//プロトコルの定義
protocol JslDismissHandlerDelegate {
    func jslhandleDismiss()
}

//ページ数を保持する変数が格納されたクラス
class JslPage: ObservableObject {
    @Published var Jslcurrentpage:Int = 0
}

//実際に表示されるView
struct JslleranViews: View {
    
    //Pageクラスのインスタンス生成
    @ObservedObject var jslpage = JslPage()
    @Binding var navigatePath: [SamplePath]
    @Binding var jslisCheckedLeft: Bool
    @Binding var jslisCheckedRight: Bool
    
    var body: some View {
        //ページ数に応じたViewを表示
        if jslpage.Jslcurrentpage == 0 && jslisCheckedLeft == true {
            JSLlearnView(jslpage: jslpage, jslalphabet: "S", jslimage: "ASL_S")
        }else if jslpage.Jslcurrentpage == 1 && jslisCheckedLeft == true {
             JSLlearnView(jslpage: jslpage, jslalphabet: "W", jslimage: "ASL_W")
        }else if jslpage.Jslcurrentpage == 2 && jslisCheckedLeft == true {
             JSLlearnView(jslpage: jslpage, jslalphabet: "I", jslimage: "ASL_I")
        }else if jslpage.Jslcurrentpage == 3 && jslisCheckedLeft == true {
              JSLlearnView(jslpage: jslpage, jslalphabet: "F", jslimage: "ASL_F")
        }else if jslpage.Jslcurrentpage == 4 && jslisCheckedLeft == true {
              JSLlearnView(jslpage: jslpage, jslalphabet: "T", jslimage: "ASL_T")
        }else if jslpage.Jslcurrentpage == 5 && jslisCheckedLeft == true {
            JSLFinishView(navigatePath: $navigatePath)
        }
        
        if jslpage.Jslcurrentpage == 0 && jslisCheckedRight == true {
            JSLlearnView(jslpage: jslpage, jslalphabet: "S", jslimage: "ASL_A_L")
        }else if jslpage.Jslcurrentpage == 1 && jslisCheckedRight == true {
            JSLlearnView(jslpage: jslpage, jslalphabet: "W", jslimage: "ASL_W_L")
        }else if jslpage.Jslcurrentpage == 2 && jslisCheckedRight == true {
            JSLlearnView(jslpage: jslpage, jslalphabet: "I", jslimage: "ASL_I_L")
        }else if jslpage.Jslcurrentpage == 3 && jslisCheckedRight == true {
            JSLlearnView(jslpage: jslpage, jslalphabet: "F", jslimage: "ASL_F_L")
        }else if jslpage.Jslcurrentpage == 4 && jslisCheckedRight == true {
            JSLlearnView(jslpage: jslpage, jslalphabet: "T", jslimage: "ASL_T_L")
        }else if jslpage.Jslcurrentpage == 5 && jslisCheckedRight == true {
            JSLFinishView(navigatePath: $navigatePath)
        }
    }
}


//Viewを定義
struct JSLlearnView: View {
    //ProgressViewを管理する変数
    @State var jslisPresentedProgressView = false
    
    // CslViewModelのインスタンス生成
    @StateObject private var jslViewModel = JslViewModel()
    
    //CorrectViewをモーダル表示するための変数
    @State private var jslcorrectModal = false
    
    //WrongViewをモーダル表示するための変数
    @State private var jslwrongModal = false
    
    //Pageクラスのインスタンスを共有する
    @ObservedObject var jslpage: JslPage
    
    //アルファベットを格納する変数
    var jslalphabet: String
    
    //指文字の画像を格納する変数
    var jslimage: String
    
    private func manageProgress(){
        //ProgressViewを表示する
        jslisPresentedProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
            //3秒後に非表示にする
            self.jslisPresentedProgressView = false
            
            //もし現在の指文字が、表示されているアルファベットと同じ場合は正解画面を表示する
            if
                jslViewModel.jslVisionClient.jslcurrentGesture.rawValue == jslalphabet {
                self.jslcorrectModal = true
            } else {
                //不正解だった場合は、不正解画面を表示する
                self.jslwrongModal.toggle()
            } 
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack{
                    Color.white
                        .ignoresSafeArea(.all)
                    
                    HStack(spacing: 45){
                        
                        Image(jslimage)
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
                        
                        Text(jslalphabet)
                            .padding()
                            .font(.system(size: 250))
                            .frame(width: geometry.size.width/3.28, height: geometry.size.height/4.72)
                            .foregroundColor(.white)
                            .background(Color.blue)
                        
                    }.position(x:geometry.size.width/2, y: geometry.size.height/4.72)
                    
                    JslCameraView(jslcamera: jslViewModel)
                        .frame(width: geometry.size.width/1.171, height: geometry.size.height/2.36)
                        .onAppear {
                            jslViewModel.start()
                        }
                        .onDisappear {
                            jslViewModel.stop()
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
                    
                    if jslisPresentedProgressView {
                        
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
        }.fullScreenCover(isPresented: self.$jslcorrectModal) { () -> JslCorrectResultView in
            
            var jslmodal = JslCorrectResultView(isPresented: self.$jslcorrectModal, jslpage: jslpage)
            jslmodal.jsldelegate = self
            return jslmodal
            
        }
        .fullScreenCover(isPresented: self.$jslwrongModal) {
            
            WrongResultView()
            
         }
       }
    }

struct JSLFinishView: View {
    @State private var jslisShowingHomeView: Bool = false
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

extension JSLlearnView : JslDismissHandlerDelegate {
    func jslhandleDismiss() {
        jslpage.Jslcurrentpage += 1
        print(jslpage.Jslcurrentpage)
    }
}
