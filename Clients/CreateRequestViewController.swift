//
//  CreateRequestViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit

class CreateRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var account: Account? = nil
    
    private var services: Array<Service> = []
    private var selectedServiceIndex: Int? = nil
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var requestTitileTextField: UITextField!
    @IBOutlet weak var servicesTableView: UITableView!
    
    override func viewDidLoad() {
        servicesTableView.dataSource = self
        servicesTableView.delegate = self
        if(account != nil) {
            accountNumberLabel.text = account?.account_number
        } else {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        if(selectedServiceIndex == nil || account == nil) {
            saveButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(account != nil && account?.account_id != nil) {
            services = CoreDataManager.instanse.fetchServicesListByAccountId(accountId: account!.account_id!)
            servicesTableView.reloadData()
        }
        servicesTableView.allowsSelection = !services.isEmpty
    }
    
    @IBAction func saveNewRequest(_ sender: Any) {
        if(account != nil && !(requestTitileTextField.text?.isEmpty ?? true) && selectedServiceIndex != nil) {
            let service = services[selectedServiceIndex!]
            CoreDataManager.instanse.createRequest(
                accountId: account!.account_id!,
                serviceId: service.service_id!,
                requestTitileTextField.text!
            )
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(services.isEmpty) {
            return 1
        }
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if(services.isEmpty) {
            cell.textLabel?.text = "Нет доступных услуг"
        } else {
            cell.textLabel?.text = services[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedServiceIndex = indexPath.row
        saveButton.isEnabled = true
    }
    
}
