//
//  NoDataView.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 13.12.24.
//
import UIKit

final class NoDataView: UILabel {
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
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 20
        
        let text = NSAttributedString(string: "NO DATA",
                                      attributes: [
                                        .shadow: shadow,
                                        .foregroundColor: UIColor.black,
                                        .font: UIFont.boldSystemFont(ofSize: 32),
                                        .kern: 8
                                      ])
        
        self.textAlignment = .center
        self.numberOfLines = 1
        self.attributedText = text
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let parent = self.superview {
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                self.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                self.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1.0),
                self.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 1.0)
            ])
        } else {
            NSLayoutConstraint.deactivate(self.constraints)
        }
    }
}
