//
//  JslCameraView.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI

// カメラのプレビューレイヤーを設定
struct JslCameraView: UIViewRepresentable {
    
    @ObservedObject var jslcamera: JslViewModel
    
    func makeUIView(context: Context) -> UIView {
        let previewView = UIView(frame: UIScreen.main.bounds)
        jslcamera.addPreviewLayer(to: previewView)
        context.coordinator.jslcamera = jslcamera
        return previewView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // ここでは何もしない。
    }
    
    //makeUIViewよりも先に呼ばれる
   func makeCoordinator() -> Coordinator {
       let jslcoordinator = Coordinator(jslcamera: jslcamera)
       jslcamera.jslVisionClient.delegate = jslcoordinator
       return jslcoordinator
   }
    
    class Coordinator: NSObject, JslDetectorDelegate {
       
        @ObservedObject var jslcamera: JslViewModel
        
        init(jslcamera: JslViewModel) {
            self.jslcamera = jslcamera
        }
        
        // CSLデリゲートメソッドを実行する
        // HandGestureを判定してcurrentGesture（画面に表示するプロパティ）に格納
        
        func jslvisionClient(_ jslVisionClient: JslVisionClient, didRecognize gesture: JslVisionClient.JslHandGesture) {
            DispatchQueue.main.async {
                // @Publishedプロパティに値を設定
                self.jslcamera.jslcurrentGesture = gesture
            }
        }
    }
}

