//
//  Account+CoreDataProperties.swift
//  Clients
//
//  Created by Максим Косенко on 29.11.2023.
//
//

import Foundation
import CoreData

@objc(Account)
public class Account: NSManagedObject, Identifiable {}

extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var account_id: UUID?
    @NSManaged public var account_number: String?
    @NSManaged public var balance: Double
    @NSManaged public var client: Client?
    @NSManaged public var requests: NSSet?
    @NSManaged public var services: NSSet?

}

// MARK: Generated accessors for requests
extension Account {

    @objc(addRequestsObject:)
    @NSManaged public func addToRequests(_ value: Request)

    @objc(removeRequestsObject:)
    @NSManaged public func removeFromRequests(_ value: Request)

    @objc(addRequests:)
    @NSManaged public func addToRequests(_ values: NSSet)

    @objc(removeRequests:)
    @NSManaged public func removeFromRequests(_ values: NSSet)

}

// MARK: Generated accessors for services
extension Account {

    @objc(addServicesObject:)
    @NSManaged public func addToServices(_ value: Service)

    @objc(removeServicesObject:)
    @NSManaged public func removeFromServices(_ value: Service)

    @objc(addServices:)
    @NSManaged public func addToServices(_ values: NSSet)

    @objc(removeServices:)
    @NSManaged public func removeFromServices(_ values: NSSet)

}
