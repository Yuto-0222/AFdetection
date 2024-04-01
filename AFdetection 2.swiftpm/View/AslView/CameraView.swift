//
//  CameraView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/13.
//

import SwiftUI

// カメラのプレビューレイヤーを設定
struct CameraView: UIViewRepresentable {
    
    @ObservedObject var camera: HandSignViewModel
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: UIScreen.main.bounds)
        camera.addPreviewLayer(to: previewView)
        context.coordinator.camera = camera
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // ここでは何もしない。
    }
    
    //makeUIViewよりも先に呼ばれる
   func makeCoordinator() -> Coordinator {
       let coordinator = Coordinator(camera: camera)
       camera.visionClient.delegate = coordinator
       return coordinator
   }
    
    class Coordinator: NSObject, HandSignDetectorDelegate {
       
        @ObservedObject var camera: HandSignViewModel
        
        init(camera: HandSignViewModel) {
            self.camera = camera
        }
        
        // ASLデリゲートメソッドを実行する
        // HandGestureを判定してcurrentGesture（画面に表示するプロパティ）に格納
        func visionClient(_ visionClient: VisionClient, didRecognize gesture: VisionClient.HandGesture) {
            DispatchQueue.main.async {
                // @Publishedプロパティに値を設定
                self.camera.currentGesture = gesture
            }
        }
    }
}

