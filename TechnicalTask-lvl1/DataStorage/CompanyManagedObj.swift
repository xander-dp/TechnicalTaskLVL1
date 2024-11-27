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
    
    //model dependency
    @NSManaged public var user: UserEntityManagedObj?
}

extension CompanyManagedObj : Identifiable {

}

extension CompanyManagedObj {
    convenience init?(context: NSManagedObjectContext, company: Company?) {
        guard let company = company else { return nil }
        
        self.init(context: context)
        
        self.name = company.name
        self.catchPhrase = company.catchPhrase
        self.bs = company.bs
    }
}
