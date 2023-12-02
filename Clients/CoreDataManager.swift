//
//  CoreDataManager.swift
//  Clients
//
//  Created by Максим Косенко on 29.11.2023.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager: NSObject {
    private let CLIENT = "Client"
    private let ACCOUNT = "Account"
    private let REQUEST = "Request"
    private let SERVICE = "Service"
    
    static let instanse = CoreDataManager()
    
    private override init(){}
    
    private var delegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        delegate.persistentContainer.viewContext
    }
}

// MARK: - Client operations
extension CoreDataManager {
    func createClient(
        _ surname: String,
        _ name: String,
        _ patronymic: String, 
        _ phone: String,
        _ adress: String
    ) {
        guard let clientEntityDescription = NSEntityDescription.entity(
            forEntityName: self.CLIENT, in: self.context
        ) else { return  }
        
        let newClient = Client(entity: clientEntityDescription, insertInto: self.context)
        newClient.full_name = surname + " " + name + " " + patronymic
        newClient.client_id = UUID()
        newClient.phone = phone
        newClient.adress = adress
        
        self.delegate.saveContext()
    }
    
    func fetchClientList() -> [Client] {
        var response: Array<Client> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.CLIENT
        )
        do {
            response = try self.context.fetch(fetchRequest) as? [Client] ?? []
        } catch {
            response = []
        }
        return response
    }
    
    func fetchClientById(clientId id: UUID) -> Client? {
        var response: Client? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.CLIENT
        )
        do {
            let clients = try self.context.fetch(fetchRequest) as? [Client] ?? []
            response = clients.first(where: {client in client.client_id == id})
        } catch {
            response = nil
        }
        return response
    }
    
    func updateClientInfo(
        clientId id: UUID,
        newPhoneNumber phone: String? = nil,
        newAdress adress: String? = nil,
        removeAccount rAccount: Account? = nil,
        addAccount newAccount: Account? = nil
    ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.CLIENT
        )
        do {
            let clients = try self.context.fetch(fetchRequest) as? [Client] ?? []
            let client = clients.first(where: {client in client.client_id == id})
            if(client != nil) {
                if(phone != nil) {
                    client?.phone = phone
                }
                if(adress != nil) {
                    client?.adress = adress
                }
                if(rAccount != nil) {
                    client?.removeFromAccounts(rAccount!)
                }
                if(newAccount != nil) {
                    client?.addToAccounts(newAccount!)
                }
                self.delegate.saveContext()
            }
        } catch {
            return
        }
    }
    
    func deleteClientById(clientId id: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.CLIENT
        )
        do {
            let clients = try self.context.fetch(fetchRequest) as? [Client] ?? []
            let client = clients.first(where: {client in client.client_id == id})
            if(client != nil) {
                self.context.delete(client!)
                self.delegate.saveContext()
            }
        } catch {
            return
        }
    }
}

// MARK: Account operations
extension CoreDataManager {
    func createAccount(
        clientId id: UUID,
        _ accontNumber: String,
        _ balance: Double
    ) {
        guard let accountEntityDescription = NSEntityDescription.entity(
            forEntityName: self.ACCOUNT, in: self.context
        ) else { return  }
        
        let client = self.fetchClientById(clientId: id)
        
        let newAccount = Account(entity: accountEntityDescription, insertInto: self.context)
        if(client != nil) {
            newAccount.client = client
            newAccount.account_id = UUID()
            newAccount.account_number = accontNumber
            newAccount.balance = balance
            self.delegate.saveContext()
        }
    }
    
    func fetchAccountsList() -> [Account] {
        var response: Array<Account> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.ACCOUNT
        )
        do {
            response = try self.context.fetch(fetchRequest) as? [Account] ?? []
        } catch {
            response = []
        }
        return response
    }
    
    func fetchAccountsListByClientId(clientId id: UUID) -> [Account] {
        var response: Array<Account> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.ACCOUNT
        )
        do {
            let accounts = try self.context.fetch(fetchRequest) as? [Account] ?? []
            for account in accounts {
                if(account.client?.client_id == id) {
                    response.append(account)
                }
            }
        } catch {
            response = []
        }
        return response
    }
    
    func fetchConnectedAccountByServiceId(serviceId id: UUID) -> [Account] {
        var response: Array<Account> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.ACCOUNT
        )
        do {
            let accounts = try self.context.fetch(fetchRequest) as? [Account] ?? []
            for account in accounts {
                let services = account.services?.allObjects as? [Service] ?? []
                if(services.isEmpty) {
                    return []
                }
                for service in services {
                    if(service.service_id != nil && service.service_id == id) {
                        response.append(account)
                        continue
                    }
                }
            }
        } catch {
            return []
        }
        return response
    }
    
    func fetchAccountById(accountId id: UUID) -> Account? {
        var response: Account? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.ACCOUNT
        )
        do {
            let accounts = try self.context.fetch(fetchRequest) as? [Account] ?? []
            response = accounts.first(where: {account in account.account_id == id})
        } catch {
            response = nil
        }
        return response
    }
    
    func updatAccount(
        accountId id: UUID,
        _ balance: Double? = nil,
        addRequest newRequest: Request? = nil,
        removeRequest request: Request? = nil,
        addService newService: Service? = nil,
        removeService service: Service? = nil
    ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.ACCOUNT
        )
        do {
            let accounts = try self.context.fetch(fetchRequest) as? [Account] ?? []
            let account = accounts.first(where: {account in account.account_id == id})
            if(account != nil) {
                if(balance != nil){
                    account?.balance = balance!
                }
                if(newRequest != nil){
                    account?.addToRequests(newRequest!)
                }
                if(request != nil) {
                    account?.removeFromRequests(request!)
                }
                if(newService != nil) {
                    account?.addToServices(newService!)
                }
                if(service != nil) {
                    account?.removeFromServices(service!)
                }
                self.delegate.saveContext()
            }
        } catch {
            return
        }
    }
    
    func deleteAccountById(accountId id: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.ACCOUNT
        )
        do {
            let accounts = try self.context.fetch(fetchRequest) as? [Account] ?? []
            let account = accounts.first(where: {account in account.account_id == id})
            if(account != nil) {
                self.context.delete(account!)
                self.delegate.saveContext()
            }
        } catch {
            return
        }
    }
}

// MARK: Service operations
extension CoreDataManager {
    func createService(
        _ name: String,
        _ price: Double
    ) {
        guard let serviceEntityDescription = NSEntityDescription.entity(
            forEntityName: self.SERVICE, in: self.context
        ) else { return }
        
        let newService = Service(entity: serviceEntityDescription, insertInto: self.context)
        newService.service_id = UUID()
        newService.name = name
        newService.price = price
        self.delegate.saveContext()
    }
    
    func fetchServiceById(serviceId id: UUID) -> Service? {
        var response: Service? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.SERVICE
        )
        do {
            let services = try self.context.fetch(fetchRequest) as? [Service] ?? []
            response = services.first(where: {service in service.service_id == id})
        } catch {
            response = nil
        }
        return response
    }
    
    func fetchServicesList() -> [Service] {
        var response: Array<Service> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.SERVICE
        )
        do {
            response = try self.context.fetch(fetchRequest) as? [Service] ?? []
        } catch {
            response = []
        }
        return response
    }
    
    func fetchServicesListByAccountId(accountId id: UUID) -> [Service] {
        var response: Array<Service> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.SERVICE
        )
        do {
            let services = try self.context.fetch(fetchRequest) as? [Service] ?? []
            for service in services {
                let accounts = service.accounts?.allObjects as? [Account] ?? []
                if(accounts.isEmpty) {
                    continue
                }
                for account in accounts {
                    if(account.account_id != nil && account.account_id == id) {
                        response.append(service)
                    }
                }
            }
        } catch {
            return []
        }
        return response
    }
    
    //MARK: - берет услуги, не подключенные к данному счету
    func fetchUnusedServicesByAccountId(accountId id: UUID) -> [Service] {
        var response: Array<Service> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.SERVICE
        )
        do {
            response = try self.context.fetch(fetchRequest) as? [Service] ?? []
            for service in response {
                let accounts = service.accounts?.allObjects as? [Account] ?? []
                if(accounts.isEmpty) {
                    continue
                }
            innerLoop: for account in accounts {
                    if(account.account_id == id) {
                        let index = response.firstIndex(of: service)
                        if(index != nil){
                            response.remove(at: index!)
                        }
                        break innerLoop
                    }
                }
            }
        } catch {
            response = []
        }
        return response
    }
    
    func updatServiceInfo(
        serviceId id: UUID,
        newAccount account: Account? = nil,
        removeAccount rAccount: Account? = nil,
        addRequest newRequest: Request? = nil,
        removeRequest request: Request? = nil,
        _ price: Double? = nil
    ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.SERVICE
        )
        do {
            let services = try self.context.fetch(fetchRequest) as? [Service] ?? []
            let service = services.first(where: {service in service.service_id == id})
            if(service != nil) {
                if(account != nil) {
                    service?.addToAccounts(account!)
                }
                if(rAccount != nil) {
                    service?.removeFromAccounts(rAccount!)
                }
                if(newRequest != nil) {
                    service?.addToRequests(newRequest!)
                }
                if(request != nil) {
                    service?.removeFromRequests(request!)
                }
                if(price != nil) {
                    service?.price = price!
                }
                self.delegate.saveContext()
            }
        } catch {
            return
        }
    }
    
    func deleteServiceById(serviceId id: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.SERVICE
        )
        do {
            let services = try self.context.fetch(fetchRequest) as? [Service] ?? []
            let service = services.first(where: {service in service.service_id == id})
            if(service != nil) {
                self.context.delete(service!)
                self.delegate.saveContext()
            }
        } catch {
            return
        }
    }
}

// MARK: Request operations
extension CoreDataManager {
    func createRequest(
        accountId aId: UUID,
        serviceId sId: UUID,
        _ title: String
    ) {
        guard let requestEntityDescription = NSEntityDescription.entity(
            forEntityName: self.REQUEST, in: self.context
        ) else { return  }
        
        let newRequest = Request(entity: requestEntityDescription, insertInto: self.context)
        let account = self.fetchAccountById(accountId: aId)
        let service = self.fetchServiceById(serviceId: sId)
        if(account != nil && service != nil) {
            newRequest.account = account
            newRequest.service = service
            newRequest.request_id = UUID()
            newRequest.title = title
            
            self.delegate.saveContext()
        }
    }
    
    func fetchRequestsList() -> [Request] {
        var response: Array<Request> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.REQUEST
        )
        do {
            response = try self.context.fetch(fetchRequest) as? [Request] ?? []
        } catch {
            response = []
        }
        return response
    }
    
    func fetchRequestById(requestId id: UUID) -> Request? {
        var response: Request? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.REQUEST
        )
        do {
            let requests = try self.context.fetch(fetchRequest) as? [Request] ?? []
            response = requests.first(where: {request in request.request_id == id})
        } catch {
            response = nil
        }
        return response
    }
    
    func fetchRequestsListByAccountId(accountId id: UUID) -> [Request] {
        var response: Array<Request> = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.REQUEST
        )
        do {
            let requests = try self.context.fetch(fetchRequest) as? [Request] ?? []
            for request in requests {
                if(request.account?.account_id == id) {
                    response.append(request)
                }
            }
        } catch {
            response = []
        }
        return response
    }
    
    func deleteRequest(requestId id: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: self.REQUEST
        )
        do {
            let requests = try self.context.fetch(fetchRequest) as? [Request] ?? []
            let request = requests.first(where: {request in request.request_id == id})
            if(request != nil) {
                self.context.delete(request!)
                self.delegate.saveContext()
            }
        } catch {
            return
        }
    }
}


