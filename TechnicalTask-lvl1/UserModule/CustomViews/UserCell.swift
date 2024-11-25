//
//  UserCell.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 25.11.24.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressMainLabel: UILabel!
    @IBOutlet weak var addressSecondaryLabel: UILabel!
    
    var entity: UserEntity! {
        didSet {
            usernameLabel?.text = entity.name
            emailLabel?.text = entity.email
            addressMainLabel?.text = entity.address.city
            addressSecondaryLabel?.text = entity.address.street
        }
    }
    
    static let reuseIdentifier = "UserContactCellIdentifier"
    static let xibName = "UserCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.wrapperView.clipsToBounds = true
        self.wrapperView.layer.borderColor = UIColor.black.cgColor
        self.wrapperView.layer.borderWidth = 3
        self.wrapperView.layer.cornerRadius = 20
        
    }
    
    func configureCell(with entityLATER: UserEntity? = nil) {
        //tmp
        let mock = getMockData()
        entity = mock[Int.random(in: 0...1)]
    }
    
    //tmp
    func getMockData() -> [UserEntity] {
        let jsonString =
        """
        [
          {
            "id": 1,
            "name": "Leanne Graham",
            "username": "Bret",
            "email": "Sincere@april.biz",
            "address": {
              "street": "Kulas Light",
              "suite": "Apt. 556",
              "city": "Gwenborough",
              "zipcode": "92998-3874",
              "geo": {
                "lat": "-37.3159",
                "lng": "81.1496"
              }
            },
            "phone": "1-770-736-8031 x56442",
            "website": "hildegard.org",
            "company": {
              "name": "Romaguera-Crona",
              "catchPhrase": "Multi-layered client-server neural-net",
              "bs": "harness real-time e-markets"
            }
          },
          {
            "id": 2,
            "name": "Ervin Howell",
            "username": "Antonette",
            "email": "Shanna@melissa.tv",
            "address": {
              "street": "Victor Plains",
              "suite": "Suite 879",
              "city": "Wisokyburgh",
              "zipcode": "90566-7771",
              "geo": {
                "lat": "-43.9509",
                "lng": "-34.4618"
              }
            },
            "phone": "010-692-6593 x09125",
            "website": "anastasia.net",
            "company": {
              "name": "Deckow-Crist",
              "catchPhrase": "Proactive didactic contingency",
              "bs": "synergize scalable supply-chains"
            }
          }
        ]
"""
        let jsonData = Data(jsonString.utf8)
        
        let decoder = JSONDecoder()

        do {
            let users = try decoder.decode([UserEntity].self, from: jsonData)
            return users
        } catch {
            print(error.localizedDescription)
        }
        
        return [UserEntity]()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
