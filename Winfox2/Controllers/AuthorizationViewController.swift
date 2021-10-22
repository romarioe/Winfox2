//
//  AuthorizationViewController.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var fromRegistrationVC: Bool = false
    var userID: String?
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
   
    
    private func setupUI(){
        self.navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.passwordTextField.isSecureTextEntry = true
        
        if fromRegistrationVC {
            //Если мы попали сюда из экрана регистрации, то вместо дефолтной кнопки назад показывем кастомную
            self.navigationItem.setHidesBackButton(true, animated: true);
            let customBackUIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(AuthorizationViewController.clickButton))
            self.navigationItem.leftBarButtonItem  = customBackUIBarButtonItem
            
            infoLabel.text = "Вы успешно зарегистрированы!"
        }
    }
    
    
    func showActivityIndicator(){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    
    @objc func clickButton(){
           //Возврат на 2 контроллера назад на главную страницу
           let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
           self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
       }
    
    
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry.toggle()
    }
    
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        validData()
    }
    
    
    
    private func showAlert(message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func validData(){
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            
            if self.emailTextField.text!.isValidEmail {
                self.showActivityIndicator()
                self.checkLogin(email: emailTextField.text!, password: passwordTextField.text!)
            } else {
                self.emailTextField.textColor = .red
                self.showAlert(message: "Email должен соответствовать формату ***@***.***")
            }
            
        } else {
            self.showAlert(message: "Необходимо заполнить все поля")
        }
 
    }
    
    
    private func checkLogin(email: String, password: String){
        let networkService = NetworkService()
        

        networkService.checkLogin(email: email, password: password) { authModel, responseCode, responseMessage in
            
            guard let authModel = authModel else {return}
            self.userID = authModel.id
            
            guard let responseCode = responseCode else {return}
            
            if responseCode == 200 {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "profileSegue", sender: nil)
                }
            } else {
                
                guard let responseMessage = responseMessage else {return}
                self.showAlert(message: responseMessage)
            }
        }
    }
    
    
    
    
    @IBAction func emailEditimgAction(_ sender: Any) {
        self.emailTextField.textColor = .black
    }
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileSegue") && fromRegistrationVC{
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.fromRegistrationVC = true
            destinationVC.email = emailTextField.text!
            
            guard let userID = self.userID else {return}
            destinationVC.userID = userID
        }
    }
    
    


}
