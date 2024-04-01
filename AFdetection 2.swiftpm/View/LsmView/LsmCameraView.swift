//
//  LsmCameraView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

// カメラのプレビューレイヤーを設定
struct LsmCameraView: UIViewRepresentable {
    
    @ObservedObject var lsmcamera: LsmViewModel
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: UIScreen.main.bounds)
        lsmcamera.addPreviewLayer(to: previewView)
        context.coordinator.lsmcamera = lsmcamera
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // ここでは何もしない。
    }
    
    //makeUIViewよりも先に呼ばれる
   func makeCoordinator() -> Coordinator {
       let lsmcoordinator = Coordinator(lsmcamera: lsmcamera)
       lsmcamera.lsmVisionClient.delegate = lsmcoordinator
       return lsmcoordinator
   }
    
    class Coordinator: NSObject, LsmDetectorDelegate {
       
        @ObservedObject var lsmcamera: LsmViewModel
        
        init(lsmcamera: LsmViewModel) {
            self.lsmcamera = lsmcamera
        }
        
        // CSLデリゲートメソッドを実行する
        // HandGestureを判定してcurrentGesture（画面に表示するプロパティ）に格納
        
        func lsmvisionClient(_ lsmVisionClient: LsmVisionClient, didRecognize gesture: LsmVisionClient.LsmHandGesture) {
            DispatchQueue.main.async {
                // @Publishedプロパティに値を設定
                self.lsmcamera.lsmcurrentGesture = gesture
            }
        }
    }
}



