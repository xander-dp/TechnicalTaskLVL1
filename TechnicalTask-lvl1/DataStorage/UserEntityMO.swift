//
//  UserEntityMO.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 11.12.24.
//

import CoreData

final class UserEntityMO: NSManagedObject, Identifiable {
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var city: String
    @NSManaged var street: String
    
    static let entityName = "User"
    @nonobjc public static func fetchRequest() -> NSFetchRequest<UserEntityMO> {
        return NSFetchRequest<UserEntityMO>(entityName: UserEntityMO.entityName)
    }
    
    convenience init(context: NSManagedObjectContext, with entity: UserEntity) {
        self.init(context: context)

        self.email = entity.email
        self.name = entity.name
        self.city = entity.city
        self.street = entity.street
    }
    
    func toUserEntity() -> UserEntity {
        UserEntity(email: self.email,
                   name: self.name,
                   city: self.city,
                   street: self.street)
    }
}
