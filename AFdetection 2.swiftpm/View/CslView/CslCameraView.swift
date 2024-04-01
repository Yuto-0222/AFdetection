//
//  CslCameraView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

// カメラのプレビューレイヤーを設定
struct CslCameraView: UIViewRepresentable {
    
    @ObservedObject var cslcamera: CslViewModel
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: UIScreen.main.bounds)
        cslcamera.addPreviewLayer(to: previewView)
        context.coordinator.cslcamera = cslcamera
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // ここでは何もしない。
    }
    
    //makeUIViewよりも先に呼ばれる
   func makeCoordinator() -> Coordinator {
       let cslcoordinator = Coordinator(cslcamera: cslcamera)
       cslcamera.cslVisionClient.delegate = cslcoordinator
       return cslcoordinator
   }
    
    class Coordinator: NSObject, CslDetectorDelegate {
       
        @ObservedObject var cslcamera: CslViewModel
        
        init(cslcamera: CslViewModel) {
            self.cslcamera = cslcamera
        }
        
        // CSLデリゲートメソッドを実行する
        // HandGestureを判定してcurrentGesture（画面に表示するプロパティ）に格納
        
        func cslvisionClient(_ cslVisionClient: CslVisionClient, didRecognize gesture: CslVisionClient.CslHandGesture) {
            DispatchQueue.main.async {
                // @Publishedプロパティに値を設定
                self.cslcamera.cslcurrentGesture = gesture
            }
        }
    }
}
