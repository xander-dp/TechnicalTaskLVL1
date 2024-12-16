//
//  myView.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 12.12.24.
//
import Foundation
import UIKit

final class ActivityIndicator: UIView {
    private let animatedLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.addSublayer(self.animatedLayer)
        layer.backgroundColor = UIColor.gray.withAlphaComponent(0.5).cgColor

        self.animatedLayer.backgroundColor = UIColor.black.cgColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let parent = self.superview {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1.0),
                self.topAnchor.constraint(equalTo: parent.layoutMarginsGuide.topAnchor),
                self.heightAnchor.constraint(equalToConstant: 2)
            ])
        } else {
            NSLayoutConstraint.deactivate(self.constraints)
        }
    }

    override func layoutSubviews() {
        createAnimation(self.frame)
    }
    
    private func createAnimation(_ frame: CGRect) {
        self.animatedLayer.removeAnimation(forKey: "flowAnimation")

        let flowAnimation = CABasicAnimation(keyPath: "position")
        flowAnimation.fromValue = [0, frame.height / 2]
        flowAnimation.toValue = [frame.width, frame.height / 2]

        flowAnimation.isRemovedOnCompletion = false
        flowAnimation.repeatCount = Float.infinity
        flowAnimation.duration = 0.5

        self.animatedLayer.add(flowAnimation, forKey: "flowAnimation")
        
        let animatableRect = CGRect(origin: .zero, size: CGSize(width: frame.width / 3, height: frame.height))
        self.animatedLayer.frame = animatableRect
    }
}
