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
    @NSManaged public var address: AddressManagedObj
    @NSManaged public var company: CompanyManagedObj?

}

extension UserEntityManagedObj : Identifiable {

}
