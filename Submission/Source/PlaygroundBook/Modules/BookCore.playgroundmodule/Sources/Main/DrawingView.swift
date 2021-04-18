//
//  DrawingView.swift
//  BookCore
//
//  Created by Zheng on 4/11/21.
//

import UIKit

class DrawingView: UIView {
    
    var checkOverlap: ((CGPoint) -> Void)? /// touch down/drag, check for line or node
    var touchUp: ((CGPoint) -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("began")
        if let firstTouch = touches.first {
            let location = firstTouch.location(in: self)
            checkOverlap?(location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touchesMoved")
        if let firstTouch = touches.first {
            let location = firstTouch.location(in: self)
            checkOverlap?(location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touchesEnded")
        if let firstTouch = touches.first {
            let location = firstTouch.location(in: self)
            touchUp?(location)
        }
    }
}
