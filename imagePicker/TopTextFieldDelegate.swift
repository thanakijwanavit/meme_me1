//
//  topTextFieldDelegate.swift
//  imagePicker
//
//  Created by nic Wanavit on 7/18/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var label = "ENTER TEXT"
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black/* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.foregroundColor: UIColor.lightGray/* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  5/* TODO: fill in appropriate Float */
    ]
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // set text attributes
        setTextAttributes(textField: textField)
        setupTextFieldStyle(toTextField: textField, defaultText: label)
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = label
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // set the text field attributes
    func setTextAttributes(textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
    }
    func setupTextFieldStyle(toTextField textField:UITextField, defaultText:String ){
        textField.textAlignment = .center
    }
}
