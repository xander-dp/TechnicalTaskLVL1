//
//  InternetMissingView.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//
import UIKit

final class NoConnectionView: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        self.isHidden = true
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 10
        
        let text = NSAttributedString(string: "NO INTERNET",
                                      attributes: [
                                        .shadow: shadow,
                                        .foregroundColor: UIColor.black,
                                        .font: UIFont.boldSystemFont(ofSize: 24),
                                        .kern: 6
                                      ])
        
        self.textAlignment = .center
        self.numberOfLines = 1
        self.attributedText = text
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let parent = self.superview {
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1.0),
                self.bottomAnchor.constraint(equalTo: parent.layoutMarginsGuide.bottomAnchor),
                self.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            NSLayoutConstraint.deactivate(self.constraints)
        }
    }
}
