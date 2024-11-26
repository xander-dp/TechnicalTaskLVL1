//
//  CompanyManagedObj.swift
//  TechnicalTask-lvl1
//
//  Created by Oleksandr Savchenko on 26.11.24.
//
import Foundation
import CoreData

@objc(CompanyManagedObj)
public class CompanyManagedObj: NSManagedObject {
    static let entityName = "Company"
}

extension CompanyManagedObj {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyManagedObj> {
        return NSFetchRequest<CompanyManagedObj>(entityName:self.entityName)
    }
    
    @NSManaged public var name: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var bs: String?
}

extension CompanyManagedObj : Identifiable {

}
