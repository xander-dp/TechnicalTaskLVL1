//
//  UserEntityManagedObj.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//

import Foundation
import CoreData

@objc(UserEntityManagedObj)
public class UserEntityManagedObj: NSManagedObject {
    static let entityName = "UserEntity"
}

extension UserEntityManagedObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntityManagedObj> {
        return NSFetchRequest<UserEntityManagedObj>(entityName: self.entityName)
    }

    @NSManaged public var email: String
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var userName: String
    @NSManaged public var website: String?
    
    //model dependency
    @NSManaged public var address: AddressManagedObj
    @NSManaged public var company: CompanyManagedObj?

}

extension UserEntityManagedObj : Identifiable {

}

extension UserEntityManagedObj {
    convenience init(context: NSManagedObjectContext, user: UserEntity) {
        self.init(context: context)
        
        self.id = Int32(user.id)
        self.name = user.name
        self.userName = user.username
        self.email = user.email
        self.phone = user.phone
        self.website = user.website
        self.address = AddressManagedObj(context: context, address: user.address)
        self.company = CompanyManagedObj(context: context, company: user.company)
        
        //model dependency
        self.address.user = self
        self.company?.user = self
    }
}
