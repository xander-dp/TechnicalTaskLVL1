//
//  GeoManagedObj.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//
import Foundation
import CoreData

@objc(GeoManagedObj)
public class GeoManagedObj: NSManagedObject {
    static let entityName = "Geo"
}

extension GeoManagedObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeoManagedObj> {
        return NSFetchRequest<GeoManagedObj>(entityName: self.entityName)
    }

    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var address: AddressManagedObj?
}

extension GeoManagedObj : Identifiable {

}
