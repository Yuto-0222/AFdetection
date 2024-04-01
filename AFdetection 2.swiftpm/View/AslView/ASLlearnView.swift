//
//  ASLlearnView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/13.
//
import SwiftUI

//プロトコルの定義
protocol DismissHandlerDelegate {
    func handleDismiss()
}

//ページ数を保持する変数が格納されたクラス
class Page: ObservableObject {
    @Published var Aslcurrentpage:Int = 0
}

//実際に表示されるView
struct ASLleranViews: View {
    
    //Pageクラスのインスタンス生成
    @ObservedObject var page = Page()
    @Binding var navigatePath: [SamplePath]
    @Binding var isCheckedLeft: Bool
    @Binding var isCheckedRight: Bool
    
    var body: some View {
        //ページ数に応じたViewを表示
        if page.Aslcurrentpage == 0 && isCheckedLeft == true {
            ASLlearnView(page: page, aslalphabet: "S", aslimage: "ASL_S")
        }else if page.Aslcurrentpage == 1 && isCheckedLeft == true {
            ASLlearnView(page: page, aslalphabet: "W", aslimage: "ASL_W")
        }else if page.Aslcurrentpage == 2 && isCheckedLeft == true {
            ASLlearnView(page: page, aslalphabet: "I", aslimage: "ASL_I")
        }else if page.Aslcurrentpage == 3 && isCheckedLeft == true {
            ASLlearnView(page: page, aslalphabet: "F", aslimage: "ASL_F")
        }else if page.Aslcurrentpage == 4 && isCheckedLeft == true {
            ASLlearnView(page: page, aslalphabet: "T", aslimage: "ASL_T")
        }else if page.Aslcurrentpage == 5 && isCheckedLeft == true {
            ASLFinishView(navigatePath: $navigatePath)
        }
        
        if page.Aslcurrentpage == 0 && isCheckedRight == true {
            ASLlearnView(page: page, aslalphabet: "S", aslimage: "ASL_A_L")
        }else if page.Aslcurrentpage == 1 && isCheckedRight == true {
            ASLlearnView(page: page, aslalphabet: "W", aslimage: "ASL_W_L")
        }else if page.Aslcurrentpage == 2 && isCheckedRight == true {
            ASLlearnView(page: page, aslalphabet: "I", aslimage: "ASL_I_L")
        }else if page.Aslcurrentpage == 3 && isCheckedRight == true {
            ASLlearnView(page: page, aslalphabet: "F", aslimage: "ASL_F_L")
        }else if page.Aslcurrentpage == 4 && isCheckedRight == true {
            ASLlearnView(page: page, aslalphabet: "T", aslimage: "ASL_T_L")
        }else if page.Aslcurrentpage == 5 && isCheckedRight == true {
            ASLFinishView(navigatePath: $navigatePath)
        }
    }
}


//Viewを定義
struct ASLlearnView: View {
    
    //ProgressViewを管理する変数
    @State var isPresentedProgressView = false
    
    // HandGestureViewModelのインスタンス生成
    @StateObject private var handSignViewModel = HandSignViewModel()
    
    //CorrectViewをモーダル表示するための変数
    @State private var correctModal = false
    
    //WrongViewをモーダル表示するための変数
    @State private var wrongModal = false
    
    //Pageクラスのインスタンスを共有する
    @ObservedObject var page: Page
    
    //アルファベットを格納する変数
    var aslalphabet: String
    
    //指文字の画像を格納する変数
    var aslimage: String
    
    //スキップボタンによる画面の切り替えを制御する変数
    @State private var isShowingView: Bool = false
    
    private func manageProgress(){
        //ProgressViewを表示する
        isPresentedProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
            //3秒後に非表示にする
            self.isPresentedProgressView = false
            
            //もし現在の指文字が、表示されているアルファベットと同じ場合は正解画面を表示する
            if handSignViewModel.visionClient.currentGesture.rawValue == aslalphabet {
                self.correctModal = true
            } else {
                //不正解だった場合は、不正解画面を表示する
                self.wrongModal.toggle()
            } 
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: geometry.size.width/18.222){
                    Image(aslimage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width/3.28, height: geometry.size.height/3.28)
                        .foregroundColor(.white)
                        .background(Color.blue)
                    
                    
                    Image(systemName: "arrowtriangle.right.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width/8.2, height: geometry.size.height/11.8)
                        .foregroundColor(.black)
                    
                    Text(aslalphabet)
                        .padding()
                        .font(.system(size: 250))
                        .frame(width: geometry.size.width/3.28, height: geometry.size.height/3.28)
                        .foregroundColor(.white)
                        .background(Color.blue)
                    
                }.position(x:geometry.size.width/2, y: geometry.size.height/4.72)
            
                CameraView(camera: handSignViewModel)
                //.position(x:geometry.size.width/2, y: geometry.size.height/1.5)
                //.frame(width: geometry.size.width/1.171, height: geometry.size.height/2.36)
                    .onAppear {
                        handSignViewModel.start()
                        print(DisplayInfo.width)
                        print(DisplayInfo.height)
                    }
                    .onDisappear {
                        handSignViewModel.stop()
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
                    
                }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2.2))
                
            if isPresentedProgressView {
                
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
                
            }.fullScreenCover(isPresented: self.$correctModal) { () -> CorrectResultView in
                
                var modal = CorrectResultView(isPresented: self.$correctModal, page: page)
                modal.asldelegate = self
                return modal
                
            }.fullScreenCover(isPresented: self.$wrongModal) {
                
                WrongResultView()
                
            }
        }
    }

struct ASLFinishView: View {
    
    @State private var isShowingHomeView: Bool = false
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

extension ASLlearnView : DismissHandlerDelegate {
    func handleDismiss() {
        page.Aslcurrentpage += 1
        print(page.Aslcurrentpage)
    }
}

