//
//  ViewController.swift
//  Books List App
//
//  Created by Audrey Welch on 1/2/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the authorization function
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            
            // Completion: if there is an error, log it and return
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
        }
    }

    
    
}

