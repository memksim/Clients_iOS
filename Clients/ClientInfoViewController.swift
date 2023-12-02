//
//  ClientInfoViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit

class ClientInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let ADD_ACCOUNT_SEGUE_ID = "add_new_account"
    private let ACCOUNT_INFO_SEGUE_ID = "account_info"
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var accountsTableView: UITableView!
    private var accounts: Array<Account> = []
    var client: Client?
    
    override func viewDidLoad() {
        if(client != nil) {
            fullNameLabel.text = client!.full_name
        }
        accountsTableView.dataSource = self
        accountsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(client != nil && client?.client_id != nil) {
            accounts = CoreDataManager.instanse.fetchAccountsListByClientId(clientId: client!.client_id!)
            accountsTableView.reloadData()
        }
        accountsTableView.allowsSelection = !accounts.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case ADD_ACCOUNT_SEGUE_ID: do {
            if let destination = segue.destination as? NewAccountViewController {
                destination.clientId = client?.client_id
            }
        }
        case ACCOUNT_INFO_SEGUE_ID: do {
            if let destination = segue.destination as? AccountInfoViewController {
                if let index = accountsTableView.indexPathForSelectedRow?.row {
                    destination.account = accounts[index]
                }
            }
        }
        default: do {}
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if(accounts.isEmpty) {
            return 1
        }
        return accounts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if(accounts.isEmpty) {
            cell.textLabel?.text = "У клиента нет открытых счетов"
        } else {
            cell.textLabel?.text = accounts[indexPath.row].account_number
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ACCOUNT_INFO_SEGUE_ID, sender: self)
    }
    
    @IBAction func createNewAccount(_ sender: Any) {
        performSegue(withIdentifier: ADD_ACCOUNT_SEGUE_ID, sender: self)
    }
    
    @IBAction func deleteClient(_ sender: Any) {
        if(client != nil && client?.client_id != nil) {
            CoreDataManager.instanse.deleteClientById(clientId: client!.client_id!)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
