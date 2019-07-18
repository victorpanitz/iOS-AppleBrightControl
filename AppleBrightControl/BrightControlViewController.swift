//
//  ViewController.swift
//  AppleBrightControl
//
//  Created by Victor Magalhaes on 14/07/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

final class BrightControlViewController: UIViewController {
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ic_home")
        
        return $0
    }(UIImageView())
    
    private let blurView: UIVisualEffectView = {
        $0.effect = UIBlurEffect(style: .dark)
        $0.frame = UIScreen.main.bounds
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return $0
    }(UIVisualEffectView())
    
    private let brightLevelView = BrightControlView()
    private let sunView = SunView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        brightLevelView.delegate = self
        
        addSubviews()
        layoutImageView()
        layoutBrightLevelView()
        layoutSunView()
    }

    // MARK: Layout
    
    private func addSubviews() {
        [imageView, blurView, brightLevelView, sunView].forEach { view.addSubview($0) }
    }
    
    private func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
    }
    
    private func layoutBrightLevelView() {
        NSLayoutConstraint.activate([
            brightLevelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/4),
            brightLevelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            brightLevelView.widthAnchor.constraint(equalToConstant: view.bounds.width*0.35),
            brightLevelView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
            ])
    }
    
    private func layoutSunView() {
        NSLayoutConstraint.activate([
            sunView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height*0.1),
            sunView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sunView.heightAnchor.constraint(equalToConstant: 0.0615 * view.frame.height),
            sunView.widthAnchor.constraint(equalToConstant: 0.0615 * view.frame.height)
            ])
    }
}

// MARK: BrightControlDelegate implementation

extension BrightControlViewController: BrightControlDelegate {
    func brightControlDidChange(value: CGFloat) {
        
        sunView.brightLevel = value.brightLevel
    }
}
