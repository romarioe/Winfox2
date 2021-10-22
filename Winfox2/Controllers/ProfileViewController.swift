//
//  ProfileViewController.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var fromRegistrationVC: Bool = false
    var preferences: [String] = []
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var avatarImageButton: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    let datepicker = UIDatePicker()
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var birthPlace: UITextField!
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var postTextField: UITextField!
    
    var avatarImage: UIImage?
    var userID: String?
    var email: String?
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createDatepicker()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarImageButton.isUserInteractionEnabled = true
        avatarImageButton.addGestureRecognizer(tapGestureRecognizer)
        
        
        lastNameTextField.delegate = self
        nameTextField.delegate = self
        patronymicTextField.delegate = self
        birthPlace.delegate = self
        birthdayTextField.delegate = self
        organizationTextField.delegate = self
        postTextField.delegate = self
    }
    
    
    func showActivityIndicator(){
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    
    private func setupUI(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        avatarImageButton.layer.cornerRadius = 50
    }
    
    
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue){
        
    }
    
    
    
    
    // MARK: - DatePicker
    
    private func createToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        return toolbar
    }
    
    
    
    func createDatepicker(){
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.datePickerMode = .date
        let loc = Locale(identifier: "ru")
        datepicker.locale = loc
        birthdayTextField.inputView = datepicker
        birthdayTextField.inputAccessoryView = createToolbar()
    }
    
    
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        self.birthdayTextField.text = dateFormatter.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: - ImagePicker
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        cameraOrLibrary()

    }
    

    
    private func cameraOrLibrary(){
        
        let alert = UIAlertController(title: "", message: "Выберите откуда вы хотите получить изображение", preferredStyle: UIAlertController.Style.alert)
        let camera = UIAlertAction(title: "Камера", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
           
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        })
        alert.addAction(camera)
        
        
        
        let galery = UIAlertAction(title: "Галерея", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        
             
         })
         alert.addAction(galery)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - LogOut
    
    private func logOut(){
        let alert = UIAlertController(title: "", message: "Вы действительно хотите выйти из системы?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Выйти", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            if self.fromRegistrationVC {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            } else {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
            
        })
        alert.addAction(ok)
        ok.setValue(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), forKey: "titleTextColor")
        
        let cancel = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(cancel)
        cancel.setValue(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), forKey: "titleTextColor")
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func logOutAction(_ sender: Any) {
        logOut()
    }
    
    
    
    
    // MARK: - ValidData and Post
    
    

    @IBAction func saveButtonAction(_ sender: Any) {
        showActivityIndicator()
        if validData() {
        
        let updateUserModel = UpdateUserModel(email: email ?? "",
                                              firstname: self.nameTextField.text!,
                                              lastname: self.lastNameTextField.text!,
                                              birthdate: self.birthdayTextField.text!,
                                              preferences: preferences,
                                              organization: self.organizationTextField.text ?? "",
                                              position: self.postTextField.text ?? "",
                                              birthPlace: self.birthPlace.text!,
                                              middlename: self.patronymicTextField.text!,
                                              id: userID ?? "")
            
            let networkService = NetworkService()
            networkService.updateProfile(profile: updateUserModel) { responseCode, responseMessage in
                
                guard let responseCode = responseCode else {return}
                if responseCode == 200 {
                    self.showAlert(message: "Данные успешно сохранены!")
                } else {
                    
                    guard let responseMessage = responseMessage else {return}
                    self.showAlert(message: responseMessage)
                }
            }
        }
    }
    
    
    
    private func validData() -> Bool{
          
        if !lastNameTextField.text!.isEmpty && !nameTextField.text!.isEmpty && !birthdayTextField.text!.isEmpty &&  !birthdayTextField.text!.isEmpty && (avatarImage != nil) && !preferences.isEmpty{
           
            return true

        } else {
            showAlert(message: "Необходимо заполнить все обязательные поля")
            return false
        }
    }
    
    
    
    private func showAlert(message: String){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

    
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "themeSegue" {
            if let destinationViewController = segue.destination as? ThemeTableViewController {
                    destinationViewController.preferences = preferences
            }
        }
    }
}




extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        avatarImageButton.image = image
        avatarImageButton.contentMode = .scaleAspectFill

        avatarImage = image
        
        let networkService = NetworkService()
        networkService.uploadAvatar(imageToUpload: image)

        dismiss(animated: true)
    }
}



