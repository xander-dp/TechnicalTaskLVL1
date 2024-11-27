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
    
    //model dependency
    @NSManaged public var geo: GeoManagedObj?
    @NSManaged public var user: UserEntityManagedObj?

}

extension AddressManagedObj : Identifiable {

}

extension AddressManagedObj {
    convenience init(context: NSManagedObjectContext, address: Address) {
        self.init(context: context)
        
        self.city = address.city
        self.street = address.street
        self.suite = address.suite
        self.zipcode = address.zipcode
        self.geo = GeoManagedObj(context: context, geo: address.geo)
        
        //model dependency
        self.geo?.address = self
    }
}
