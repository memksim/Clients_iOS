//
//  ServiceInfoViewController.swift
//  Clients
//
//  Created by Максим Косенко on 02.12.2023.
//

import Foundation
import UIKit

class ServiceInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let ACCOUNT_INFO_SEGUE_ID = "service_info_to_account_info"
    
    var service: Service? = nil
    private var connectedAccounts: Array<Account> = []
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var connectedAccountsTableView: UITableView!
    
    override func viewDidLoad() {
        connectedAccountsTableView.dataSource = self
        connectedAccountsTableView.delegate = self
        if(service != nil) {
            serviceNameLabel.text = service?.name
            priceLabel.text = String(service?.price ?? 0.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(service != nil && service?.service_id != nil) {
            connectedAccounts = CoreDataManager.instanse.fetchConnectedAccountByServiceId(serviceId: service!.service_id!)
            connectedAccountsTableView.reloadData()
        }
        connectedAccountsTableView.allowsSelection = !connectedAccounts.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AccountInfoViewController {
            if let index = connectedAccountsTableView.indexPathForSelectedRow?.row {
                destination.account = connectedAccounts[index]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(connectedAccounts.isEmpty) {
            return 1
        }
        return connectedAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if(connectedAccounts.isEmpty) {
            cell.textLabel?.text = "Нет использующих счетов"
        } else {
            cell.textLabel?.text = connectedAccounts[indexPath.row].account_number
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ACCOUNT_INFO_SEGUE_ID, sender: self)
    }
    
    @IBAction func deleteService(_ sender: Any) {
        if(service != nil) {
            CoreDataManager.instanse.deleteServiceById(serviceId: service!.service_id!)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
