//
//  Request+CoreDataProperties.swift
//  Clients
//
//  Created by Максим Косенко on 29.11.2023.
//
//

import Foundation
import CoreData

@objc(Request)
public class Request: NSManagedObject, Identifiable {

}

extension Request {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Request> {
        return NSFetchRequest<Request>(entityName: "Request")
    }

    @NSManaged public var title: String?
    @NSManaged public var request_id: UUID?
    @NSManaged public var account: Account?
    @NSManaged public var service: Service?

}

