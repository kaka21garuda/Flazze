//
//  Post.swift
//  Flazze
//
//  Created by Buka Cakrawala on 10/15/16.
//  Copyright © 2016 Buka Cakrawala. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct Post {
    let title: String
    let content: String
    let addedByUser: String
    let dataRef: FIRDatabaseReference?
    
    init(title: String = "", content: String, addedByUser: String) {
        self.title = title
        self.content = content
        self.addedByUser = addedByUser
        self.dataRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
       
        title = snapshot.key
        dataRef = snapshot.ref
        
        let i = snapshot.value as! NSDictionary
        
        if let postContent = i["content"] as? String {
            content = postContent
        } else {
            content = ""
        }
        
        if let postUser = i["addedByUser"] as? String {
            addedByUser = postUser
        } else {
            addedByUser = ""
        }
        
        
    }
    
}

