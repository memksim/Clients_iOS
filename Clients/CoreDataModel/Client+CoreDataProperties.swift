//
//  Client+CoreDataProperties.swift
//  Clients
//
//  Created by Максим Косенко on 29.11.2023.
//
//

import Foundation
import CoreData

@objc(Client)
public class Client: NSManagedObject, Identifiable {}

extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var client_id: UUID?
    @NSManaged public var full_name: String?
    @NSManaged public var phone: String?
    @NSManaged public var adress: String?
    @NSManaged public var accounts: NSSet?

}

// MARK: Generated accessors for accounts
extension Client {

    @objc(addAccountsObject:)
    @NSManaged public func addToAccounts(_ value: Account)

    @objc(removeAccountsObject:)
    @NSManaged public func removeFromAccounts(_ value: Account)

    @objc(addAccounts:)
    @NSManaged public func addToAccounts(_ values: NSSet)

    @objc(removeAccounts:)
    @NSManaged public func removeFromAccounts(_ values: NSSet)

}

