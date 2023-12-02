//
//  NewServiceInfoViewController.swift
//  Clients
//
//  Created by Максим Косенко on 02.12.2023.
//

import Foundation
import UIKit

class NewServiceInfoViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var serviceNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        saveButton.isEnabled = !(serviceNameTextField.text?.isEmpty ?? true)
    }
    
    @IBAction func serviceNameTextChanged(_ sender: UITextField) {
        saveButton.isEnabled = !(serviceNameTextField.text?.isEmpty ?? true)
    }
    
    @IBAction func saveService(_ sender: Any) {
        let price = Double(priceTextField.text ?? "0.0") ?? 0.0
        CoreDataManager.instanse.createService(
            serviceNameTextField.text ?? "",
            price
        )
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
