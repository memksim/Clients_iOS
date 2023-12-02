//
//  RequestInfoViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit

class RequestInfoViewController: UIViewController {
    
    var request: Request? = nil
    
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var requestTitleLabel: UILabel!
    
    override func viewDidLoad() {
        if(request != nil) {
            accountNumberLabel.text = request!.account?.account_number
            serviceNameLabel.text = request!.service?.name
            requestTitleLabel.text = request!.title
        }
    }
    
    @IBAction func deleteRequest(_ sender: Any) {
        if(request != nil) {
            CoreDataManager.instanse.deleteRequest(requestId: request!.request_id!)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
