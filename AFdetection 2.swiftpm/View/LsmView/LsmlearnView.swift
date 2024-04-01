//
//  LsmlearnView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

//プロトコルの定義
protocol LsmDismissHandlerDelegate {
    func lsmhandleDismiss()
}

//ページ数を保持する変数が格納されたクラス
class LsmPage: ObservableObject {
    @Published var Lsmcurrentpage:Int = 0
}

//実際に表示されるView
struct LsmleranViews: View {
    
    //Pageクラスのインスタンス生成
    @ObservedObject var lsmpage = LsmPage()
    
    @Binding var navigatePath: [SamplePath]
    
    @Binding var lsmisCheckedLeft: Bool
    @Binding var lsmisCheckedRight: Bool
    
    var body: some View {
        //ページ数に応じたViewを表示
        if lsmpage.Lsmcurrentpage == 0 && lsmisCheckedLeft == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "S", lsmimage: "ASL_S")
        }else if lsmpage.Lsmcurrentpage == 1 && lsmisCheckedLeft == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "W", lsmimage: "ASL_W")
        }else if lsmpage.Lsmcurrentpage == 2 && lsmisCheckedLeft == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "I", lsmimage: "ASL_I")
        }else if lsmpage.Lsmcurrentpage == 3 && lsmisCheckedLeft == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "F", lsmimage: "ASL_F")
        }else if lsmpage.Lsmcurrentpage == 4 && lsmisCheckedLeft == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "T", lsmimage: "ASL_T")
        }else if lsmpage.Lsmcurrentpage == 5 && lsmisCheckedLeft == true {
            LsmFinishView(navigatePath: $navigatePath)
        }
        
        if lsmpage.Lsmcurrentpage == 0 && lsmisCheckedRight == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "S", lsmimage: "ASL_A_L")
        }else if lsmpage.Lsmcurrentpage == 1 && lsmisCheckedRight == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "W", lsmimage: "ASL_W_L")
        }else if lsmpage.Lsmcurrentpage == 2 && lsmisCheckedRight == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "I", lsmimage: "ASL_I_L")
        }else if lsmpage.Lsmcurrentpage == 3 && lsmisCheckedRight == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "F", lsmimage: "ASL_F_L")
        }else if lsmpage.Lsmcurrentpage == 4 && lsmisCheckedRight == true {
            LSMlearnView(lsmpage: lsmpage, lsmalphabet: "T", lsmimage: "ASL_T_L")
        }else if lsmpage.Lsmcurrentpage == 5 && lsmisCheckedRight == true {
            LsmFinishView(navigatePath: $navigatePath)
        }
    }
}

//Viewを定義
struct LSMlearnView: View {
    
    //ProgressViewを管理する変数
    @State var lsmisPresentedProgressView = false
    
    // CslViewModelのインスタンス生成
    @StateObject private var lsmViewModel = LsmViewModel()
    
    //CorrectViewをモーダル表示するための変数
    @State private var lsmcorrectModal = false
    
    //WrongViewをモーダル表示するための変数
    @State private var lsmwrongModal = false
    
    //Pageクラスのインスタンスを共有する
    @ObservedObject var lsmpage: LsmPage
    
    //アルファベットを格納する変数
    var lsmalphabet: String
    
    //指文字の画像を格納する変数
    var lsmimage: String
    
    private func manageProgress(){
        //ProgressViewを表示する
        lsmisPresentedProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
            //3秒後に非表示にする
            self.lsmisPresentedProgressView = false
            
            //もし現在の指文字が、表示されているアルファベットと同じ場合は正解画面を表示する
            if
                lsmViewModel.lsmVisionClient.lsmcurrentGesture.rawValue == lsmalphabet {
                self.lsmcorrectModal = true
            } else {
                //不正解だった場合は、不正解画面を表示する
                self.lsmwrongModal.toggle()
            } 
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack{
                    Color.white
                        .ignoresSafeArea(.all)
                    
                    HStack(spacing: 45){
                        
                        Image(lsmimage)
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
                        
                        Text(lsmalphabet)
                            .padding()
                            .font(.system(size: 250))
                            .frame(width: geometry.size.width/3.28, height: geometry.size.height/4.72)
                            .foregroundColor(.white)
                            .background(Color.blue)
                        
                    }.position(x:geometry.size.width/2, y: geometry.size.height/4.72)
                    
                    LsmCameraView(lsmcamera: lsmViewModel)
                        .frame(width: geometry.size.width/1.171, height: geometry.size.height/2.36)
                        .onAppear {
                            lsmViewModel.start()
                        }
                        .onDisappear {
                            lsmViewModel.stop()
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
                    
                    if lsmisPresentedProgressView {
                        
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
        }.fullScreenCover(isPresented: self.$lsmcorrectModal) { () -> LsmCorrectResultView in
            
            var lsmmodal = LsmCorrectResultView(isPresented: self.$lsmcorrectModal, lsmpage: lsmpage)
            lsmmodal.lsmdelegate = self
            return lsmmodal
            
        }
        .fullScreenCover(isPresented: self.$lsmwrongModal) {
            
            WrongResultView()
            
         }
       }
    }

struct LsmFinishView: View {
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


extension LSMlearnView : LsmDismissHandlerDelegate {
    func lsmhandleDismiss() {
        lsmpage.Lsmcurrentpage += 1
        print(lsmpage.Lsmcurrentpage)
    }
}


