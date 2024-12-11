//
//  UserCell.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 25.11.24.
//

import UIKit
import Combine

class UserCell: UITableViewCell {
    static let reuseIdentifier = "UserContactCellIdentifier"
    static let xibName = "UserCell"

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressMainLabel: UILabel!
    @IBOutlet weak var addressSecondaryLabel: UILabel!
    
    private var model: UserPresntationModel! {
        didSet {
            usernameLabel?.text = model.name
            emailLabel?.text = model.email
            addressMainLabel?.text = model.city
            addressSecondaryLabel?.text = model.street
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.wrapperView.clipsToBounds = true
        self.wrapperView.layer.borderColor = UIColor.black.cgColor
        self.wrapperView.layer.borderWidth = 3
        self.wrapperView.layer.cornerRadius = 20
    }
    
    var cancellable: AnyCancellable? // 1
    
    func configureCell(with model: UserPresntationModel) {
        self.model = model
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
    
}
