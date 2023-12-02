//
//  AddServiceViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit

class AddServiceViewController: UIViewController, UITableViewDataSource {
    
    var account: Account? = nil
    
    private var servicesList: Array<Service> = []
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var servicesTableView: UITableView!
    
    override func viewDidLoad() {
        servicesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(account != nil && account?.account_id != nil) {
            servicesList = CoreDataManager.instanse.fetchUnusedServicesByAccountId(accountId: account!.account_id!)
            servicesTableView.reloadData()
        }
        selectButton.isEnabled = !servicesList.isEmpty
        servicesTableView.allowsSelection = !servicesList.isEmpty
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(servicesList.count == 0) { return 1 }
        return servicesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(servicesList.count == 0) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Нет доступных услуг"
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = servicesList[indexPath.row].name
            return cell
        }
    }
    
    @IBAction func addServiceToAccount(_ sender: Any) {
        if(account != nil) {
            if let index = servicesTableView.indexPathForSelectedRow?.row {
                let id = servicesList[index].service_id
                if(id != nil) {
                    CoreDataManager.instanse.updatServiceInfo(
                        serviceId: id!,
                        newAccount: account
                    )
                    navigationController?.popViewController(animated: true)
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
