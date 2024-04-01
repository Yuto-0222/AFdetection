//
//  CSLlearnView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

//プロトコルの定義
protocol CslDismissHandlerDelegate {
    func cslhandleDismiss()
}

//ページ数を保持する変数が格納されたクラス
class CslPage: ObservableObject {
    @Published var Cslcurrentpage:Int = 0
}

//実際に表示されるView
struct CslleranViews: View {
    
    //Pageクラスのインスタンス生成
    @ObservedObject var cslpage = CslPage()
    @Binding var navigatePath: [SamplePath]
    @Binding var cslisCheckedLeft: Bool
    @Binding var cslisCheckedRight: Bool
    
    var body: some View {
        //ページ数に応じたViewを表示
        if cslpage.Cslcurrentpage == 0 && cslisCheckedLeft == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "S", cslimage: "CSL_S")
        }else if cslpage.Cslcurrentpage == 1 && cslisCheckedLeft == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "W", cslimage: "ASL_W")
        }else if cslpage.Cslcurrentpage == 2 && cslisCheckedLeft == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "I", cslimage: "CSL_I")
        }else if cslpage.Cslcurrentpage == 3 && cslisCheckedLeft == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "F", cslimage: "ASL_F")
        }else if cslpage.Cslcurrentpage == 4 && cslisCheckedLeft == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "T", cslimage: "CSL_T")
        }else if cslpage.Cslcurrentpage == 5 && cslisCheckedLeft == true {
            CSLFinishView(navigatePath: $navigatePath)
        }
        
        if cslpage.Cslcurrentpage == 0 && cslisCheckedRight == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "S", cslimage: "CSL_S_L")
        }else if cslpage.Cslcurrentpage == 1 && cslisCheckedRight == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "W", cslimage: "ASL_W_L")
        }else if cslpage.Cslcurrentpage == 2 && cslisCheckedRight == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "I", cslimage: "CSL_I_L")
        }else if cslpage.Cslcurrentpage == 3 && cslisCheckedRight == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "F", cslimage: "ASL_F_L")
        }else if cslpage.Cslcurrentpage == 4 && cslisCheckedRight == true {
            CSLlearnView(cslpage: cslpage, cslalphabet: "T", cslimage: "CSL_T_L")
        }else if cslpage.Cslcurrentpage == 5 && cslisCheckedRight == true {
            CSLFinishView(navigatePath: $navigatePath)
        }
    }
}


//Viewを定義
struct CSLlearnView: View {
    
    //ProgressViewを管理する変数
    @State var cslisPresentedProgressView = false
    
    // CslViewModelのインスタンス生成
    @StateObject private var cslViewModel = CslViewModel()
    
    //CorrectViewをモーダル表示するための変数
    @State private var cslcorrectModal = false
    
    //WrongViewをモーダル表示するための変数
    @State private var cslwrongModal = false
    
    //Pageクラスのインスタンスを共有する
    @ObservedObject var cslpage: CslPage
    
    //アルファベットを格納する変数
    var cslalphabet: String
    
    //指文字の画像を格納する変数
    var cslimage: String
    
    private func manageProgress(){
        //ProgressViewを表示する
        cslisPresentedProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
            //3秒後に非表示にする
            self.cslisPresentedProgressView = false
            
            //もし現在の指文字が、表示されているアルファベットと同じ場合は正解画面を表示する
            if cslViewModel.cslVisionClient.cslcurrentGesture.rawValue == cslalphabet {
                self.cslcorrectModal = true
            } else {
                //不正解だった場合は、不正解画面を表示する
                self.cslwrongModal.toggle()
            } 
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.white
                    .ignoresSafeArea(.all)
                
                HStack(spacing: 45){
                    
                    Image(cslimage)
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
                    
                    Text(cslalphabet)
                        .padding()
                        .font(.system(size: 250))
                        .frame(width: geometry.size.width/3.28, height: geometry.size.height/4.72)
                        .foregroundColor(.white)
                        .background(Color.blue)
                    
                }.position(x:geometry.size.width/2, y: geometry.size.height/4.72)
                
                CslCameraView(cslcamera: cslViewModel)
                    .frame(width: geometry.size.width/1.171, height: geometry.size.height/2.36)
                    .onAppear {
                        cslViewModel.start()
                    }
                    .onDisappear {
                        cslViewModel.stop()
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
                
                if cslisPresentedProgressView {
                    
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
                
            }.fullScreenCover(isPresented: self.$cslcorrectModal) { () -> CslCorrectResultView in
                
                var cslmodal = CslCorrectResultView(isPresented: self.$cslcorrectModal, cslpage: cslpage)
                cslmodal.csldelegate = self
                return cslmodal
                
            }
            .fullScreenCover(isPresented: self.$cslwrongModal) {
                
                WrongResultView()
                
            }
        }
    }
}

struct CSLFinishView: View {
    @State private var cslisShowingHomeView: Bool = false
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

extension CSLlearnView : CslDismissHandlerDelegate {
    func cslhandleDismiss() {
        cslpage.Cslcurrentpage += 1
        print(cslpage.Cslcurrentpage)
    }
}
