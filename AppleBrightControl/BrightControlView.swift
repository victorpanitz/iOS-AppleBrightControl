//
//  BrightControlView.swift
//  AppleBrightControl
//
//  Created by Victor Magalhaes on 18/07/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol BrightControlDelegate: AnyObject {
    func brightControlDidChange(value: CGFloat)
}

final class BrightControlView: UIView {
    
    var delegate: BrightControlDelegate?
    private lazy var level: CGFloat = UIScreen.main.brightness
    
    private lazy var sliderPath: UIBezierPath = {
        $0.move(to: CGPoint(x: bounds.midX, y: bounds.height))
        $0.addLine(to: CGPoint(x: bounds.midX, y: 0))
        
        return $0
    }(UIBezierPath())
    
    private lazy var levelLayer: CAShapeLayer = {
        $0.path = sliderPath.cgPath
        $0.strokeColor = UIColor.white.withAlphaComponent(0.8).cgColor
        $0.lineWidth = bounds.width
        $0.strokeEnd = level
        
        return $0
    }(CAShapeLayer())
    
    private var didLayout = false {
        didSet {
            if didLayout {
                setupSelf()
                setupLevelLayer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupSelf()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        !didLayout ? (didLayout = true) : ()
    }
    
    private func setupSelf() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = frame.width/4
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
    
    private func setupLevelLayer() {
        layer.addSublayer(levelLayer)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(pan)
    }
    
    // MARK: Handle user drag interaction
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: gesture.view)
        let percent = translation.y / bounds.height
        
        level = max(0, min(1, levelLayer.strokeEnd - percent))
        
        animateDisablingActions {
            levelLayer.strokeEnd = level
            UIScreen.main.brightness = CGFloat(level)
        }

        delegate?.brightControlDidChange(value: level)
        gesture.setTranslation(.zero, in: gesture.view)
    }
    
}

// MARK: extension responsible to remove implicit animations

fileprivate extension BrightControlView {
    func animateDisablingActions(_ animations: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animations()
        CATransaction.commit()
    }
}
