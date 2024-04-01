//
//  JslViewModel.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import SwiftUI
import AVFoundation
import Vision

class JslViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate, JslDetectorDelegate {
    
    let jslVisionClient: JslVisionClient
    
    //SwiftHandPoseClassifierのインスタンス生成
    //SwiftHandPoseClassifierを初期化
    let model = try? SwiftHandPoseClassifier(configuration: MLModelConfiguration())
    
    // AVCaptureSessionのインスタンス生成
    private let session = AVCaptureSession()
    private var delegate: JslDetectorDelegate?
    
    //指文字取得に関するプロパティ
    var frameCounter: Int = 0
    let handPosePredictionInterval: Int = 30
    var currentHandPoseObservation: VNHumanHandPoseObservation?

    @Published var jslcurrentGesture: JslVisionClient.JslHandGesture = .unknown
    
    override init() {
        jslVisionClient = JslVisionClient()
        super.init()
        jslVisionClient.delegate = self
        do {
            session.sessionPreset = .photo
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            if let device = device {
                let input = try AVCaptureDeviceInput(device: device)
                session.addInput(input)
                let output = AVCaptureVideoDataOutput()
                output.setSampleBufferDelegate(self, queue: .main)
                session.addOutput(output)
                let view = UIView(frame: UIScreen.main.bounds)
                addPreviewLayer(to: view)
                session.commitConfiguration()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func jslvisionClient(_ jslVisionClient: JslVisionClient, didRecognize gesture: JslVisionClient.JslHandGesture) {
        //何もしない
    }
    
        // キャプチャを停止するメソッド
        func stop() {
            if session.isRunning {
                session.stopRunning()
            }
        }
        
        // キャプチャを再開するメソッド
        func start() {
            if session.isRunning == false {
                // 非同期処理をバックグラウンドスレッドで実行
                DispatchQueue.global().async {
                    self.session.startRunning()
                }
            }
        }
        
        // キャプチャセッションから得られたカメラ映像を表示するためのレイヤーを追加するメソッド
        func addPreviewLayer(to view: UIView) {
            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.frame = CGRect(x: 0, y: DisplayInfo.height/4.37, width: DisplayInfo.width/1.171, height: DisplayInfo.height/2.145)
            layer.borderWidth = 5
            layer.borderColor = UIColor.black.cgColor
            layer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(layer) // UIViewにAVCaptureVideoPreviewLayerを追加
        }
    
        // AVCaptureVideoDataOutputから取得した動画フレームからてのジェスチャーを検出するメソッド
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }

            DispatchQueue.global(qos: .userInitiated).async { [self] in
                let handPoseRequest = VNDetectHumanHandPoseRequest()
                handPoseRequest.maximumHandCount = 1
                handPoseRequest.revision = VNDetectHumanHandPoseRequestRevision1
                
                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,orientation: .right , options: [:])
                do {
                    try handler.perform([handPoseRequest])
                } catch {
                    assertionFailure("HandPoseRequest failed: \(error)")
                }
                
                guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else { return }
                guard let observation = handPoses.first else { return }
                currentHandPoseObservation = observation
                frameCounter += 1
                if frameCounter % handPosePredictionInterval == 0 {
                    frameCounter = 0
                    makePrediction(handPoseObservation: observation)
                }
            }
            // 実際にジェスチャーからHandGestureを判別する
            //jslVisionClient.processObservations(observations)
        }
    
    func makePrediction(handPoseObservation: VNHumanHandPoseObservation) {
        // 手のポイントの検出結果を多次元配列に変換
        guard let keypointsMultiArray = try? handPoseObservation.keypointsMultiArray() else { fatalError() }
        do {
            
            // モデルに入力して推論実行
            let prediction = try model!.prediction(poses: keypointsMultiArray)
            let label = prediction.label // 最も信頼度の高いラベル
            guard let confidence = prediction.labelProbabilities[label] else { return } // labelの信頼度
            //研究用
            print("label:\(prediction.label)\nconfidence:\(confidence)")
            //信頼度が70%以上の時、ラベルに応じてCurrentGestureの値を変更する
            if confidence > 0.7 {
                DispatchQueue.main.async { [self] in
                    switch label {
                    case "S":jslVisionClient.jslcurrentGesture = .S
                    case "W":jslVisionClient.jslcurrentGesture = .W
                    case "I":jslVisionClient.jslcurrentGesture = .I
                    case "F":jslVisionClient.jslcurrentGesture = .F
                    case "T":jslVisionClient.jslcurrentGesture = .T
                    default : break
                    }
                }
            }
        } catch {
            print("Prediction error")
        }    
    }
}


