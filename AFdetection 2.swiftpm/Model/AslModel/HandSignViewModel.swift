//
//  HandSignViewModel.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/13.
//

import SwiftUI
import AVFoundation
import Vision

class HandSignViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate, HandSignDetectorDelegate {
    //VisionClientのインスタンス生成
    let visionClient: VisionClient
    
    //SwiftHandPoseClassifierのインスタンス生成
    //SwiftHandPoseClassifierを初期化
    let model = try? SwiftHandPoseClassifier(configuration: MLModelConfiguration())
    
    // AVCaptureSessionのインスタンス生成
    private let session = AVCaptureSession()
    private var delegate: HandSignDetectorDelegate?
    var frameCounter: Int = 0
    let handPosePredictionInterval: Int = 30
    var currentHandPoseObservation: VNHumanHandPoseObservation?

    @Published var currentGesture: VisionClient.HandGesture = .unknown
    
    override init() {
        visionClient = VisionClient()
        super.init()
        visionClient.delegate = self
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
    
    func visionClient(_ visionClient: VisionClient, didRecognize gesture: VisionClient.HandGesture) {
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
            layer.frame = CGRect(x: 110, y:580, width: 600, height: 500)
            layer.borderWidth = 5
            layer.borderColor = UIColor.black.cgColor
            layer.videoGravity = .resizeAspectFill
            layer.connection?.videoOrientation = .portrait
            view.layer.addSublayer(layer) // UIViewにAVCaptureVideoPreviewLayerを追加
            print(layer.frame)
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
            //visionClient.processObservations(observations)
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
                    case "S":visionClient.currentGesture = .S
                    case "W":visionClient.currentGesture = .W
                    case "I":visionClient.currentGesture = .I
                    case "F":visionClient.currentGesture = .F
                    case "T":visionClient.currentGesture = .T
                    default : break
                    }
                }
            }
        } catch {
            print("Prediction error")
        }    
    }
}

