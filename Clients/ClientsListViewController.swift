//
//  ClientsListViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit


class ClientsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var clientsTableView: UITableView!
    
    private var clients: Array<Client> = []
    
    override func viewDidLoad() {
        clientsTableView.dataSource = self
        clientsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clients = CoreDataManager.instanse.fetchClientList()
        clientsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = clients[indexPath.row].full_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "client info", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClientInfoViewController {
            if let index = clientsTableView.indexPathForSelectedRow?.row {
                destination.client = clients[index]
            }
        }
    }
    
}
