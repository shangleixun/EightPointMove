//
//  TouchView.swift
//  MultiPointsMove
//
//  Created by 尚雷勋 on 2020/8/26.
//

import UIKit

class MPMBaseTouchView: UIView {
    
    public var point: MPMPoint = MPMPoint.zero
    private var panBlock: ((UIGestureRecognizer.State, CGPoint) -> Void)?
    
    public func setPanBlock(_ block: @escaping (UIGestureRecognizer.State, CGPoint) -> Void) {
        panBlock = block
    }
    
    public init(frame: CGRect, point: MPMPoint) {
        super.init(frame: frame)
        self.point = point
        // addLongPressGesture()
        addPanGesture()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent(_:)))
        self.addGestureRecognizer(longPress)
    }
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func longPressEvent(_ sender: UILongPressGestureRecognizer) {
        guard sender.view != nil else {
            return
        }
        panBlock?(sender.state, sender.location(in: self))
    }
    
    @objc public func panEvent(_ sender: UIPanGestureRecognizer) {
        
        guard sender.view != nil else {
            return
        }
        
        if sender.state == .changed {
            
            point.point = sender.location(in: superview)
            
            if let su = superview as? MPMBaseShowView,
               let limitPoint = su.pointManager.limit(point: point) {
                // 更新 touch 的 point
                self.point = limitPoint
                panBlock?(sender.state, limitPoint.point)
            }
            
        }
    }
    
}

class MPMTouchViewRound: MPMBaseTouchView {
    
    public override init(frame: CGRect, point: MPMPoint) {
        super.init(frame: frame, point: point)
        
        layer.cornerRadius = frame.width/2.0
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            backgroundColor = UIColor.cyan.withAlphaComponent(0.4)
        }
        if sender.state == .ended || sender.state == .cancelled {
            backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        super.panEvent(sender)
        
    }
    
}

class MPMTouchViewLine: MPMBaseTouchView {
    
    public override init(frame: CGRect, point: MPMPoint) {
        super.init(frame: frame, point: point)
        
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            backgroundColor = UIColor.cyan.withAlphaComponent(0.4)
        }
        if sender.state == .ended || sender.state == .cancelled {
            backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        // 手势应该是垂直方向
        if sender.direction.isVertical {
            
            super.panEvent(sender)
        }
    }
    
}
