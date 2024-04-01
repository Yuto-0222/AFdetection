//
//  DisplayInfo.swift
//  HandSign
//
//  Created by 山田雄斗 on 2024/02/13.
//

import Foundation
import UIKit


struct DisplayInfo {
    
    private static var window: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    static var screenSize: CGRect {
        return window?.screen.bounds ?? CGRect.zero
    }
    
    static var width: CGFloat {
        return screenSize.width
    }
    
    static var height: CGFloat {
        return screenSize.height
    }
}
