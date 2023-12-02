//
//  AccountInfoViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit

class AccountInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let ADD_SERVICE_SEGUE_ID = "add_service"
    private let REQUEST_INFO_SEGUE_ID = "request_info"
    private let CREATE_REQUEST_SEGUE_ID = "create_request"
    
    var account: Account? = nil
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var requestsTableView: UITableView!
    
    private var servicesList: Array<Service> = []
    private var requestsList: Array<Request> = []
    
    override func viewDidLoad() {
        servicesTableView.dataSource = self
        requestsTableView.dataSource = self
        servicesTableView.delegate = self
        requestsTableView.delegate = self
        if(account != nil) {
            numberLabel.text = account!.account_number
            balanceLabel.text = String(account!.balance)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(account != nil && account?.account_id != nil){
            servicesList = CoreDataManager.instanse.fetchServicesListByAccountId(accountId: account!.account_id!)
            servicesTableView.reloadData()
            requestsList = CoreDataManager.instanse.fetchRequestsListByAccountId(accountId: account!.account_id!)
            requestsTableView.reloadData()
        }
        requestsTableView.allowsSelection = !requestsList.isEmpty
    }
    
    @IBAction func deleteAccount(_ sender: UIBarButtonItem) {
        if(account != nil && account?.account_id != nil){
            CoreDataManager.instanse.deleteAccountById(
                accountId: account!.account_id!
            )
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addServiceToAccount(_ sender: UIButton) {
        if(account != nil) {
            performSegue(withIdentifier: REQUEST_INFO_SEGUE_ID, sender: self)

        }
    }
    
    @IBAction func createRequest(_ sender: UIButton) {
        if(account != nil) {
            performSegue(withIdentifier: CREATE_REQUEST_SEGUE_ID, sender: self)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch tableView {
            case servicesTableView: do {
                if(servicesList.count == 0) {
                    return 1
                }
                return servicesList.count
            }
            case requestsTableView: do {
                if(requestsList.count == 0) {
                    return 1
                }
                return requestsList.count
            }
            default: return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch tableView {
            case servicesTableView: do {
                let cell = UITableViewCell(
                    style: .default, reuseIdentifier: nil
                )
                if(servicesList.count == 0) {
                    cell.textLabel?.text = "Нет подключенных услуг"
                } else {
                    cell.textLabel?.text = servicesList[indexPath.row].name
                }
                return cell
            }
            case requestsTableView: do {
                let cell = UITableViewCell(
                    style: .default, reuseIdentifier: nil
                )
                if(requestsList.count == 0) {
                    cell.textLabel?.text = "Нет заявок по данному счету"
                } else {
                    cell.textLabel?.text = requestsList[indexPath.row].title
                }
                return cell
            }
            default: return UITableViewCell()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if(tableView == requestsTableView) {
            performSegue(withIdentifier: REQUEST_INFO_SEGUE_ID, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case REQUEST_INFO_SEGUE_ID: do {
                if let destination =
                    segue.destination as? RequestInfoViewController {
                    if let index = requestsTableView.indexPathForSelectedRow?.row {
                        destination.request = requestsList[index]
                    }
                }
            }
            case ADD_SERVICE_SEGUE_ID: do {
                if let destination = 
                    segue.destination as? AddServiceViewController {
                    destination.account = account
                }
            }
            case CREATE_REQUEST_SEGUE_ID: do {
                if let destination =
                    segue.destination as? CreateRequestViewController {
                    destination.account = account
                }
            }
            default: do {}
        }
    }
}

