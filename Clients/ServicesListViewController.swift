//
//  ServicesListViewController.swift
//  Clients
//
//  Created by Максим Косенко on 02.12.2023.
//

import Foundation
import UIKit

class ServicesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let SERVICE_INFO_SEGUE_ID = "service_info"
    
    private var servicesList: Array<Service> = []
    
    @IBOutlet weak var servicesTableView: UITableView!
    
    override func viewDidLoad() {
        servicesTableView.dataSource = self
        servicesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        servicesList = CoreDataManager.instanse.fetchServicesList()
        servicesTableView.reloadData()
        servicesTableView.allowsSelection = !servicesList.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ServiceInfoViewController {
            if let index = servicesTableView.indexPathForSelectedRow?.row {
                destination.service = servicesList[index]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(servicesList.isEmpty) { return 1 }
        return servicesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if(servicesList.isEmpty) {
            cell.textLabel?.text = "Нет доступных услуг"
        } else {
            cell.textLabel?.text = servicesList[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SERVICE_INFO_SEGUE_ID, sender: self)
    }

}
