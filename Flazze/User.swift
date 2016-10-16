//
//  User.swift
//  Flazze
//
//  Created by Buka Cakrawala on 10/15/16.
//  Copyright © 2016 Buka Cakrawala. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

struct User {
    let uid: String
    let email: String
    
    init(userData: FIRUser) {
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}


