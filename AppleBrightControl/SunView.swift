//
//  SunView.swift
//  AppleBrightControl
//
//  Created by Victor Magalhaes on 18/07/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

final class SunView: UIView {
    
    // MARK: Layers
    
    private let sunLine = CALayer()
    private let sunCircle = CALayer()
    private let replicatorLayer = CAReplicatorLayer()
    
    // MARK: Animation constants
    
    private let sunLineAnimation: CABasicAnimation = {
        $0.keyPath = "bounds.size.width"
        $0.duration = 0.2
        $0.fillMode = CAMediaTimingFillMode.forwards
        $0.isRemovedOnCompletion = false
        
        return $0
    }(CABasicAnimation())
    
    private let sunSizeAnimation: CABasicAnimation = {
        $0.keyPath = "bounds.size"
        $0.duration = 0.2
        $0.fillMode = CAMediaTimingFillMode.forwards
        $0.isRemovedOnCompletion = false
        
        return $0
    }(CABasicAnimation())
    
    private let sunCornerRadiusAnimation: CABasicAnimation = {
        $0.keyPath = "cornerRadius"
        $0.duration = 0.2
        $0.fillMode = CAMediaTimingFillMode.forwards
        $0.isRemovedOnCompletion = false
        
        return $0
    }(CABasicAnimation())

    private let pulseAnimation: CASpringAnimation = {
        $0.keyPath = "transform.scale"
        $0.duration = 0.5
        $0.fromValue = 1.0
        $0.toValue = 1.02
        $0.initialVelocity = 0.5
        $0.damping = 0.5
        
        return $0
    }(CASpringAnimation())
    
    // Layout state
    
    private var didLayout = false {
        didSet {
            if didLayout { layoutSunLayer() }
        }
    }
    
    // Bright control states
    
    var brightLevel: BrightLevel = UIScreen.main.brightness.brightLevel {
        didSet {
            handleBrightControl()
        }
    }
    
    private lazy var previousBrightLevel : BrightLevel = brightLevel
    
    // Lifecycle methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { return nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        !didLayout ? (didLayout = true) : ()
    }
    
    // MARK: Layout
    
    private func layoutSunLayer(){
        let side: CGFloat = bounds.width - (0.175 * bounds.width)
        let diameter: CGFloat = 0.55 * side
        
        setupSunCircleLayer(radius: diameter/2)
        setupSunLinesLayer(side: side)
        setupReplicatorLayer(side: side)
        
        layer.addSublayer(sunCircle)
        layer.addSublayer(replicatorLayer)
    }
    
    private func setupReplicatorLayer(side: CGFloat) {
        replicatorLayer.frame = CGRect(x: bounds.midX - side/2, y: bounds.midY - side/2, width: side, height: side)
        replicatorLayer.addSublayer(sunLine)
        
        let sunLineCount = 8
        replicatorLayer.instanceCount = sunLineCount
        
        let angle = -CGFloat.pi * 2 / CGFloat(sunLineCount)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
    }
    
    private func setupSunCircleLayer(radius: CGFloat) {
        sunCircle.frame = CGRect(x: bounds.midX - radius, y: bounds.midY - radius, width: radius*2, height: radius*2)
        sunCircle.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        sunCircle.cornerRadius = radius
    }
    
    private func setupSunLinesLayer(side: CGFloat) {
        let lenght: CGFloat = 0.175 * side
        let thickness: CGFloat = 0.075 * side
        
        sunLine.frame = CGRect(x: 0, y: 0, width: lenght, height: thickness)
        sunLine.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        sunLine.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        sunLine.position = CGPoint(x: side/10, y: side/2)
        sunLine.cornerRadius = thickness/2
    }
    
    // MARK: Animations
    
    private func handleBrightControl() {
        switch brightLevel {
        case .max:
            pulseSun()
        default:
            animateSun()
        }
    }
    
    private func animateSun() {
        guard previousBrightLevel.value != brightLevel.value else {
            previousBrightLevel = brightLevel
            return
        }
        
        let sunWidth = sunCircle.bounds.width
        let prevFactor = previousBrightLevel.value.limited
        let curFactor = brightLevel.value.limited
        
        setupSunLinesAnimation()
        setupSunSizeAnimation(sunWidth: sunWidth, factors: (last: prevFactor, next: curFactor))
        setupSunCornerRadiusAnimation(factors: (last: prevFactor, next: curFactor))
        
        sunLine.add(sunLineAnimation, forKey: "sunLineAnimation")
        sunCircle.add(sunSizeAnimation, forKey: "sunCircleAnimation")
        sunCircle.add(sunCornerRadiusAnimation, forKey: "sunCornerRadiusAnimation")
        
        previousBrightLevel = brightLevel
    }
    
    private func setupSunLinesAnimation() {
        sunLineAnimation.fromValue = sunLine.bounds.width * previousBrightLevel.value
        sunLineAnimation.toValue = sunLine.bounds.width * brightLevel.value
    }
    
    private func setupSunSizeAnimation(sunWidth: CGFloat, factors: (last:CGFloat, next: CGFloat)) {
        sunSizeAnimation.fromValue = previousBrightLevel == .low
            ? CGSize(width: sunWidth * factors.last * 1.7, height: sunWidth * factors.last * 1.7)
            : sunCircle.bounds.size
        
        sunSizeAnimation.toValue = brightLevel == .low
            ? CGSize(width: sunWidth * factors.next * 1.7, height: sunWidth * factors.next * 1.7)
            : sunCircle.bounds.size
    }
    
    private func setupSunCornerRadiusAnimation(factors: (last:CGFloat, next: CGFloat)) {
        sunCornerRadiusAnimation.fromValue = previousBrightLevel == .low
            ? sunCircle.cornerRadius * factors.last * 1.7
            : sunCircle.cornerRadius
        
        sunCornerRadiusAnimation.toValue = brightLevel == .low
            ? sunCircle.cornerRadius * factors.next * 1.7
            : sunCircle.cornerRadius
    }
    
    private func pulseSun() {
        guard previousBrightLevel != BrightLevel.max else { return }

        replicatorLayer.add(pulseAnimation, forKey: "spring")
        sunCircle.add(pulseAnimation, forKey: "springSun")
        
        previousBrightLevel = .max
    }
}
