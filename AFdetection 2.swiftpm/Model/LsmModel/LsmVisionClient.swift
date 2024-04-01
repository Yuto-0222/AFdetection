//
//  LsmVisionClient.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/19.
//

import Foundation
import Vision

// デリゲートのプロトコルを定義
protocol LsmDetectorDelegate: AnyObject {
    
    func lsmvisionClient(_ lsmVisionClient: LsmVisionClient, didRecognize gesture: LsmVisionClient.LsmHandGesture)
    
}

class LsmVisionClient: ObservableObject {
    
    // 手首の座標データ
    @Published var wristPosition: CGPoint = .zero
    //親指の先の座標データ
    @Published var thumbTIpPosition: CGPoint = .zero
    //中指の先の座標データ
    @Published var middleTipPosition: CGPoint = .zero
    //中指の第二関節の座標データ
    @Published var middlePIPPosition: CGPoint = .zero
    //人差し指の先の座標データ
    @Published var indexTipPosition: CGPoint = .zero
    
    // 指文字の種類のenum
    enum LsmHandGesture: String {
        case A = "A"
        case B = "B"
        case C = "C"
        case D = "D"
        case E = "E"
        case F = "F"
        case G = "G"
        case H = "H"
        case I = "I"
        case J = "J"
        case K = "K"
        case L = "L"
        case M = "M"
        case N = "N"
        case O = "O"
        case P = "P"
        case Q = "Q"
        case R = "R"
        case S = "S"
        case T = "T"
        case U = "U"
        case V = "V"
        case W = "W"
        case X = "X"
        case Y = "Y"
        case Z = "Z"
        case unknown = "？？？"
    }
    
    // デリゲートを持たせるためのプロパティ
    weak var delegate: LsmDetectorDelegate?
    
    // デリゲートメソッドに渡す用のHandGestureプロパティ
    //CSLの指文字を格納
    var lsmcurrentGesture: LsmHandGesture = .unknown {
        
        //currentGestureが変更された時に実行される
        didSet {
            delegate?.lsmvisionClient(self, didRecognize: lsmcurrentGesture)
        }
        
    }
    
    // デリゲートを初期化
    init(delegate: LsmDetectorDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - メソッド
    func createDetectionRequest(pixelBuffer: CVPixelBuffer) throws -> VNImageBasedRequest {
        // 人間の手を検出するリクエストクラスのインスタンス生成
        let request = VNDetectHumanHandPoseRequest()
        // 画像内で検出する手の最大数
        request.maximumHandCount = 1
        // 画像内に関する１つ以上の画像分析を要求する処理
        try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        return request
    }
    
    // HandPoseを判別するメソッド
    func processObservations(_ observations: [VNRecognizedPointsObservation]) {
        guard let points = try? observations.first?.recognizedPoints(forGroupKey: .all) else {
            return
        }

        // 指先
        let thumbTIp = points[VNHumanHandPoseObservation.JointName.thumbTip.rawValue]?.location ?? .zero//親指の指先
        let indexTip = points[VNHumanHandPoseObservation.JointName.indexTip.rawValue]?.location ?? .zero//人差し指の指先
        let middleTip = points[VNHumanHandPoseObservation.JointName.middleTip.rawValue]?.location ?? .zero//中指の指先
        let ringTip = points[VNHumanHandPoseObservation.JointName.ringTip.rawValue]?.location ?? .zero//薬指の指先
        let littleTip = points[VNHumanHandPoseObservation.JointName.littleTip.rawValue]?.location ?? .zero//小指の指先
        
        //第一関節取得
        let thumbIP = points[VNHumanHandPoseObservation.JointName.thumbIP.rawValue]?.location ?? .zero//親指の第一関節
        let indexDIP = points[VNHumanHandPoseObservation.JointName.indexDIP.rawValue]?.location ?? .zero//人差し指の第一関節
        let middleDIP = points[VNHumanHandPoseObservation.JointName.middleDIP.rawValue]?.location ?? .zero//中指の第一関節
        let ringDIP = points[VNHumanHandPoseObservation.JointName.ringDIP.rawValue]?.location ?? .zero//薬指の第一関節
        let littleDIP = points[VNHumanHandPoseObservation.JointName.littleDIP.rawValue]?.location ?? .zero//小指の第一関節
        
        // 近位指節間(PIP)関節 ＝ 第二関節を取得
        let thumbMP = points[VNHumanHandPoseObservation.JointName.thumbMP.rawValue]?.location ?? .zero
        let indexPIP = points[VNHumanHandPoseObservation.JointName.indexPIP.rawValue]?.location ?? .zero
        let middlePIP = points[VNHumanHandPoseObservation.JointName.middlePIP.rawValue]?.location ?? .zero
        let ringPIP = points[VNHumanHandPoseObservation.JointName.ringPIP.rawValue]?.location ?? .zero
        let littlePIP = points[VNHumanHandPoseObservation.JointName.littlePIP.rawValue]?.location ?? .zero
        
        //付け根の取得
        let thumbCMC = points[VNHumanHandPoseObservation.JointName.thumbCMC.rawValue]?.location ?? .zero
        let indeMCP = points[VNHumanHandPoseObservation.JointName.indexMCP.rawValue]?.location ?? .zero
        let middleMCP = points[VNHumanHandPoseObservation.JointName.middleMCP.rawValue]?.location ?? .zero
        let ringMCP = points[VNHumanHandPoseObservation.JointName.ringMCP.rawValue]?.location ?? .zero
        let littleMCP = points[VNHumanHandPoseObservation.JointName.littleMCP.rawValue]?.location ?? .zero
        
        // 手首
        let wrist = points[VNHumanHandPoseObservation.JointName.wrist.rawValue]?.location ?? .zero

        // 手首から指先の長さ
        let wristTothumbTIP = distance(from: wrist, to: thumbTIp)//手首から親指の指先
        let wristToIndexTip = distance(from: wrist, to: indexTip)//手首から人差し指の指先
        let wristToMiddleTip = distance(from: wrist, to: middleTip)//手首から中指の指先
        let wristToRingTip = distance(from: wrist, to: ringTip)//手首から薬指の指先
        let wristToLittleTip = distance(from: wrist, to: littleTip)//手首から小指の指先
        
        // 手首から第一関節の長さ
        let wristToThumbIP = distance(from: wrist, to: thumbIP)//手首から親指の第一関節
        let wristToIndexDIP = distance(from: wrist, to: indexDIP)//手首から人差し指の第一関節
        let wristToMiddleDIP = distance(from: wrist, to: middleDIP)//手首から中指の第一関節
        let wristToRingDIP = distance(from: wrist, to: ringDIP)//手首から薬指の指先の第一関節
        let wristToLittleDIP = distance(from: wrist, to: littleDIP)//手首から小指の指先の第一関節

        // 手首から近位指節間(PIP)関節＝第二関節の長さ
        let wristToThumbMP = distance(from: wrist, to: thumbMP)//手首から親指の第二関節
        let wristToIndexPIP = distance(from: wrist, to: indexPIP)//手首から人差し指の第二関節
        let wristToMiddlePIP = distance(from: wrist, to: middlePIP)//手首から中指の第二関節
        let wristToRingPIP = distance(from: wrist, to: ringPIP)//手首から薬指の指先の第二関節
        let wristToLittlePIP = distance(from: wrist, to: littlePIP)//手首から小指の指先の第二関節
        
        //手首から指の付け根までの長さ
        let wristTothumbcmc = distance(from: wrist, to: thumbMP)//手首から親指の第二関節
        let wristToindexmcp = distance(from: wrist, to: indexPIP)//手首から人差し指の第二関節
        let wristTomiddleMCP = distance(from: wrist, to: middlePIP)//手首から中指の第二関節
        let wristToringMCP = distance(from: wrist, to: ringPIP)//手首から薬指の指先の第二関節
        let wristTolittleMCP = distance(from: wrist, to: littlePIP)//手首から小指の指先の第二関節
        
        //手首から指先の角度
        //let anglewristTothumbTIP = angle(a: wrist, b: thumbTIp)

        // HandPoseの判定(どの指が曲がっているかでA〜Zを判定する）
        //条件分岐に関しては、指文字がAなのか、そうではないのか、そうでない場合はBなのか、を繰り返す。
        if
            wristToIndexTip < wristToIndexPIP &&
                wristToMiddleTip < wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP && wristToLittleTip < wristToLittlePIP && wristTothumbTIP > wristTothumbcmc {
            //親指以外は曲がっているかつ、親指は曲がってない場合なので、A
            //曲がっていない場合は、手首から指の付け根までの長さよりも、手首から指の先までの長さが長いときとする
            lsmcurrentGesture = .A
        }
        else if
            wristTothumbTIP < wristToLittleDIP  &&
                wristToindexmcp < wristToIndexTip &&
                wristTomiddleMCP < wristToMiddleTip &&
                wristToringMCP < wristToRingTip && wristTolittleMCP < wristToLittleTip {
            //親指は曲がっているかつ、それ以外の指は曲がっていないので、B
            //また、より正確な指文字を行うことができるように、親指の先は、小指の第一関節よりも下にあるという条件を追加
            lsmcurrentGesture = .B
            
        } else if
            wristTothumbTIP > wristTothumbcmc &&
                wristToIndexDIP < wristToIndexTip &&
                wristToMiddleDIP < wristToMiddleTip &&
                wristToRingDIP < wristToRingTip && wristToLittleDIP < wristToLittleTip {
            //全ての指を曲げるが、完全に曲げるわけではない。
            //軽く曲げる程度なので、全て曲げていないと判断する。
            lsmcurrentGesture = .C
            
        } else if
            wristToIndexTip > wristToIndexPIP &&
            wristToMiddlePIP > wristToMiddleTip &&
                wristToRingPIP > wristToRingTip && wristToLittlePIP < wristToLittleTip{
            //全ての指が曲がっている。
            //親指の先の位置は、人差し指の第二関節よりも下である。
            lsmcurrentGesture = .D
            
        } else if
            wristToIndexTip < wristToIndexPIP &&
                wristToMiddleTip < wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP &&
                wristToLittleTip < wristToLittlePIP && wristToIndexTip > wristTothumbTIP {
            lsmcurrentGesture = .E
            
            //全ての指は曲げているが、手首から親指の先までの長さよりも、手首から人差し指の先の長さの方が長いという条件つき
        } else if
                wristToMiddlePIP < wristToMiddleTip &&
                wristToRingPIP < wristToRingTip && wristToLittlePIP < wristToLittleTip {
            //中指、薬指、小指の3つが曲げられているかつ、人差し指と親指は曲げていない。
            lsmcurrentGesture = .F
            
        }  else if
            wristToMiddleTip < wristToMiddlePIP &&
            wristToRingTip < wristToRingPIP && wristToLittleTip < wristToLittlePIP
        {
            lsmcurrentGesture = .G
            
        } else if
            
            wristToIndexTip > wristToIndexPIP &&
                wristToMiddleTip > wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP &&
                wristToLittleTip < wristToLittlePIP && wristToThumbMP < wristTothumbTIP && thumbTIpPosition.y < middleTipPosition.y {
            lsmcurrentGesture = .K
                
        }  else if
            wristToMiddleTip > wristToMiddlePIP &&
            wristToRingTip < wristToRingPIP && wristToLittleTip < wristToLittlePIP && thumbTIpPosition.y > middleTipPosition.y
            {
            lsmcurrentGesture = .H
            
        } else if
            
            wristToIndexTip < wristToIndexPIP &&
                wristToMiddleTip < wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP &&
                wristToLittleTip > wristToLittleDIP && wristToIndexPIP > wristTothumbTIP {
            lsmcurrentGesture = .I
                
        } else if
            wristToIndexTip > wristToIndexPIP &&
                wristToMiddleTip < wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP && wristToLittleTip < wristToLittlePIP && wristTothumbTIP > wristToThumbMP && indexTipPosition.x < thumbTIpPosition.x  {
            lsmcurrentGesture = .L
            
        } /*else if
            wristTothumbTIP > wristToLittleDIP  &&
                wristToIndexPIP < wristToIndexTip &&
                wristToMiddlePIP < wristToMiddleTip &&
                wristToRingPIP < wristToRingTip && wristToLittleDIP > wristToLittleTip {
            //中指、薬指、小指の3つが曲げられているかつ、人差し指と親指は曲げていない。
            currentGesture = .W
        }*/ else if
            wristToThumbIP < wristTothumbTIP &&
                wristToIndexTip < wristToIndexPIP &&
                wristToMiddleTip < wristToMiddlePIP &&
                wristToRingTip < wristToRingPIP && wristToLittleDIP < wristToLittleTip {
            //中指、薬指、小指の3つが曲げられているかつ、人差し指と親指は曲げていない。
            lsmcurrentGesture = .Y
        } else if
            wristToIndexTip > wristToIndexPIP &&
            wristToMiddleTip > wristToMiddlePIP && wristTothumbTIP < wristToThumbMP {
            lsmcurrentGesture = .V
            
        } /*else if
            
            wristToMiddleTip < wristToMiddlePIP &&
            wristToRingTip < wristToRingPIP &&
            wristToLittleTip < wristToLittlePIP && wristToIndexDIP < wristToIndexTip{
            currentGesture = .X
            
        }*/  else {
            lsmcurrentGesture = .unknown
        }

        // processObservationsの中で、delegate経由でcurrentGestureを通知する
        delegate?.lsmvisionClient(self, didRecognize: lsmcurrentGesture)

        // MARK: - 研究用
        wristPosition = wrist
        thumbTIpPosition = thumbTIp
        middleTipPosition = middleTip
        middlePIPPosition = middlePIP
        indexTipPosition = indexTip
        print("テスト: thumbTIp \(thumbTIpPosition)")
        print("テスト: middleTip \(middleTipPosition)")
        //print("テスト: angle \(anglewristTothumbTIP)")
        
        //以下仮の条件分岐
        
    }

    // 画面上の２点間の距離を三平方の定理より求める
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }
    
    // 画面上の2点から角度を求める
    private func angle(a:CGPoint, b:CGPoint) -> CGFloat {
        
        var r = atan2(b.y - a.y, b.x - a.x)
        if r < 0 {
            r = r + 2 * Double.pi
        }
        return floor(r * 360 / (2 * Double.pi))
    }
    
}
