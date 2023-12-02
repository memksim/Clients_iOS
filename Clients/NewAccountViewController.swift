//
//  NewAccountViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit

class NewAccountViewController: UIViewController {
    
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    
    var clientId: UUID? = nil
    
    @IBAction func saveNewAccount(_ sender: UIBarButtonItem) {
        if(checkFieldsFilled() && clientId != nil) {
            let number = "л/с: " + (accountNumberTextField.text ?? "1234567890")
            CoreDataManager.instanse.createAccount(
                clientId: self.clientId!,
                number,
                Double(balanceTextField.text ?? "0.0") ?? 0.0
            )
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func checkFieldsFilled() -> Bool {
        return !(accountNumberTextField.text?.isEmpty ?? true)
        && !(balanceTextField.text?.isEmpty ?? true)
    }
    
}
