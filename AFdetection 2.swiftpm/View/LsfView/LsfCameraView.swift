//
//  LsfCameraView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

// カメラのプレビューレイヤーを設定
struct LsfCameraView: UIViewRepresentable {
    
    @ObservedObject var lsfcamera: LsfViewModel
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: UIScreen.main.bounds)
        lsfcamera.addPreviewLayer(to: previewView)
        context.coordinator.lsfcamera = lsfcamera
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // ここでは何もしない。
    }
    
    //makeUIViewよりも先に呼ばれる
   func makeCoordinator() -> Coordinator {
       let lsfcoordinator = Coordinator(lsfcamera: lsfcamera)
       lsfcamera.lsfVisionClient.delegate = lsfcoordinator
       return lsfcoordinator
   }
    
    class Coordinator: NSObject, LsfDetectorDelegate {
       
        @ObservedObject var lsfcamera: LsfViewModel
        
        init(lsfcamera: LsfViewModel) {
            self.lsfcamera = lsfcamera
        }
        
        // CSLデリゲートメソッドを実行する
        // HandGestureを判定してcurrentGesture（画面に表示するプロパティ）に格納
        
        func lsfvisionClient(_ lsfVisionClient: LsfVisionClient, didRecognize gesture: LsfVisionClient.LsfHandGesture) {
            DispatchQueue.main.async {
                // @Publishedプロパティに値を設定
                self.lsfcamera.lsfcurrentGesture = gesture
            }
        }
    }
}


