//
//  NewClientViewController.swift
//  Clients
//
//  Created by Максим Косенко on 30.11.2023.
//

import Foundation
import UIKit

class NewClientViewController: UIViewController {
    
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var adresTextField: UITextField!
    
    @IBAction func saveDidClicked(_ sender: UIBarButtonItem) {
        if(checkAllFieldsFilled()){
            CoreDataManager.instanse.createClient(
                surnameTextField.text ?? "empy surname",
                nameTextField.text ?? "empty name",
                patronymicTextField.text ?? "empty patronymic",
                phoneTextField.text ?? "empty phone",
                adresTextField.text ?? "empty adres"
            )
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func checkAllFieldsFilled() -> Bool {
        return !(nameTextField.text?.isEmpty ?? true)
        && !(surnameTextField.text?.isEmpty ?? true)
        && !(patronymicTextField.text?.isEmpty ?? true)
        && !(phoneTextField.text?.isEmpty ?? true)
        && !(adresTextField.text?.isEmpty ?? true)
    }
}
