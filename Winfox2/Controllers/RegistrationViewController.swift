//
//  RegistrationViewController.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var lastNameTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        lastNameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        nameTextField.delegate = self
        patronymicTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    
    private func setupUI(){
        self.navigationItem.title = "Регистрация"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.passwordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.isSecureTextEntry = true
    }
    
    
    func showActivityIndicator(){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
        
    
    
    private func validData(){
        if !lastNameTextField.text!.isEmpty && !nameTextField.text!.isEmpty && !patronymicTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !confirmPasswordTextField.text!.isEmpty {

            if self.passwordTextField.text! == self.confirmPasswordTextField.text! {

                if self.emailTextField.text!.isValidEmail {
                    showActivityIndicator()
                    registerUser(email: self.emailTextField.text!,
                                 firstname: self.nameTextField.text!,
                                 lastname: self.lastNameTextField.text!,
                                 password: self.passwordTextField.text!)
                } else {
                    self.emailTextField.textColor = .red
                    self.showAlert(message: "Email должен соответствовать формату ***@***.***")
                }

            } else {
                self.passwordTextField.textColor = .red
                self.confirmPasswordTextField.textColor = .red
                self.showAlert(message: "Пароли не совпадают")
            }



        } else {
            self.showAlert(message: "Необходимо заполнить все поля")
        }
        
  
    }
    
    private func registerUser(email: String, firstname: String, lastname: String, password: String){
        let networkService = NetworkService()
        
        networkService.registerUser(firstname: firstname,
                                    lastname: lastname,
                                    email: email,
                                    password: password) { userModel, responseMessage in
            if let responseMessage = responseMessage {
                self.showAlert(message: responseMessage)
            } else {

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "authSegue", sender: nil)
                }
                
            }
        }
        }
    
    

    
    
    @IBAction func showPasswordButton(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry.toggle()
        self.confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    
    
    @IBAction func registerActionButton(_ sender: Any) {
        validData()
    }
    
    
    private func showAlert(message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func emailEditimgAction(_ sender: Any) {
        self.emailTextField.textColor = .black
    }
    
    
    
    @IBAction func passwordEditingAction(_ sender: Any) {
        self.passwordTextField.textColor = .black
        self.confirmPasswordTextField.textColor = .black

    }
    
    
    @IBAction func confirmPasswordEditingAction(_ sender: Any) {
        self.passwordTextField.textColor = .black
        self.confirmPasswordTextField.textColor = .black

    }
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "authSegue"{
            let destinationVC = segue.destination as! AuthorizationViewController
            destinationVC.fromRegistrationVC = true
        }
    }
    

}




