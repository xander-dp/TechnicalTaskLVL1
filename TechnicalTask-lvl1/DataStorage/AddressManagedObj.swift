//
//  AddressManagedObj.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//
import Foundation
import CoreData

@objc(AddressManagedObj)
public class AddressManagedObj: NSManagedObject {
    static let entityName = "Address"
}

extension AddressManagedObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressManagedObj> {
        return NSFetchRequest<AddressManagedObj>(entityName: self.entityName)
    }

    @NSManaged public var city: String
    @NSManaged public var street: String
    @NSManaged public var suite: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var geo: GeoManagedObj?
    @NSManaged public var user: UserEntityManagedObj?

}

extension AddressManagedObj : Identifiable {

}
