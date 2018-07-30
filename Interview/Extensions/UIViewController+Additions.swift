//
//  UIViewController+Additions.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    typealias completion = (_ weather: String) -> Void

    
    func showAlert(withTitle title: String ,andMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextField( _ completion: @escaping(completion)) {
        
        let alert = UIAlertController(title: "Enter weather", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "enter the weather"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            
            if let textFields = alert.textFields, let textField = textFields.first, let text = textField.text {
                completion(text)
            }
            
        }))

        self.present(alert, animated: true, completion: nil)

        
    }
    
}
