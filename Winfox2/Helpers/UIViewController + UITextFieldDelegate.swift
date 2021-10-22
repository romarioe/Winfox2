//
//  UIViewController + UITextFieldDelegate.swift
//  Winfox2
//
//  Created by Roman Efimov on 22.10.2021.
//

import Foundation
import UIKit




extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
