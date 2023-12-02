//
//  Service+CoreDataProperties.swift
//  Clients
//
//  Created by Максим Косенко on 29.11.2023.
//
//

import Foundation
import CoreData

@objc(Service)
public class Service: NSManagedObject, Identifiable {}

extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var service_id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var accounts: NSSet?
    @NSManaged public var requests: NSSet?

}

// MARK: Generated accessors for accounts
extension Service {

    @objc(addAccountsObject:)
    @NSManaged public func addToAccounts(_ value: Account)

    @objc(removeAccountsObject:)
    @NSManaged public func removeFromAccounts(_ value: Account)

    @objc(addAccounts:)
    @NSManaged public func addToAccounts(_ values: NSSet)

    @objc(removeAccounts:)
    @NSManaged public func removeFromAccounts(_ values: NSSet)

}

// MARK: Generated accessors for requests
extension Service {

    @objc(addRequestsObject:)
    @NSManaged public func addToRequests(_ value: Request)

    @objc(removeRequestsObject:)
    @NSManaged public func removeFromRequests(_ value: Request)

    @objc(addRequests:)
    @NSManaged public func addToRequests(_ values: NSSet)

    @objc(removeRequests:)
    @NSManaged public func removeFromRequests(_ values: NSSet)

}
