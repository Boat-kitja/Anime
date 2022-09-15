//
//  ViewController.swift
//  ListOfPutang
//
//  Created by Kitja  on 25/8/2565 BE.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordCheckTextfield: UITextField!
    
    let apiCall = ApiCall()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func registerPressed(_ sender: UIButton){
        if passwordTextfield.text == passwordCheckTextfield.text{
            if let email = emailTextfield.text, let password = passwordTextfield.text {
                Auth.auth().createUser(withEmail: email, password: password) {
                    authResult, error in
                    if error != nil {
                        let alert = UIAlertController(title: "Register Failed", message: "Use Correct Format Email.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Register success", message: nil, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default){ (action) in
                            self.navigationController?.popToRootViewController(animated: true)}
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Register Failed", message: "Input Email Password or Password not match.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}

