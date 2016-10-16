//
//  ViewController.swift
//  Flazze
//
//  Created by Buka Cakrawala on 10/15/16.
//  Copyright © 2016 Buka Cakrawala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UITableViewController {
    
    var dbRef: FIRDatabaseReference!
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        dbRef = FIRDatabase.database().reference().child("post-items")
        
        startObservingDB()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //to check wether the user need to create an account or just login with their account
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("Welcome \(user.email)")
                self.startObservingDB()
            } else {
                print("You need to sign up/login first!")
            }
        })
    }
    
    
    func startObservingDB() {
        dbRef.observe(.value, with: { (snapshot) in
            var newPosts = [Post]()
            
            for post in snapshot.children {
                let postObject = Post(snapshot: post as! FIRDataSnapshot)
                newPosts.append(postObject)
            }
            
            self.posts = newPosts
            self.tableView.reloadData()
            
            }) { (error) in
                print(error)
        }
    }
    
    @IBAction func loginOrSignup(_ sender: AnyObject) {
        let userAlert = UIAlertController(title: "Login/Signup", message: "Enter email and password", preferredStyle: .alert)
        userAlert.addTextField { (emailField) in
            emailField.placeholder = "Email"
        }
        userAlert.addTextField { (passField) in
            passField.isSecureTextEntry = true
            passField.placeholder = "Password"
        }
        
        userAlert.addAction(UIAlertAction(title: "Sign in", style: .default, handler: { (action) in
            let emailTextField = userAlert.textFields?.first
            let passwordTextField = userAlert.textFields?.first
            
            FIRAuth.auth()?.signIn(withEmail: (emailTextField?.text)!, password: (passwordTextField?.text)!, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            })
        }))
        
        userAlert.addAction(UIAlertAction(title: "Sign up", style: .default, handler: { (action) in
            let emailTextField = userAlert.textFields?.first
            let passwordTextField = userAlert.textFields?.first
            
            FIRAuth.auth()?.createUser(withEmail: (emailTextField?.text)!, password: (passwordTextField?.text)!, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            })
        }))
        
        self.present(userAlert, animated: true, completion: nil)
    }

    @IBAction func addButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Post", message: "Enter you post here!", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Your Post"
        }
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action) in
            //to grab the post that the user has already type in 
            if let postContent = alert.textFields?.first?.text {
                // this is the post object that can be passed to Firebase Database
                let post  = Post(content: postContent, addedByUser: "user")
                
                let postRef = self.dbRef.child(postContent.lowercased())
                
                postRef.setValue(post.toAnyObject())
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.content
        cell.detailTextLabel?.text = post.addedByUser
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //when the editing is .delete
        if editingStyle == .delete {
            let post = posts[indexPath.row]
            //remove post with a specific indexPath from the database
            post.dataRef?.removeValue()
        }
    }
    

}

