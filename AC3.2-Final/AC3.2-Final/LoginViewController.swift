//
//  LoginViewController.swift
//  AC3.2-Final
//
//  Created by Ilmira Estil on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    private let segue = "loginSegue"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var currentUserUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentUserUid != nil {
            dump(currentUserUid)
        }
    }
    
    @IBAction func loginToFB(_ sender: UIButton) {
        print("pressed login")
        //loginAnonymously()
        loginUser()
    }
    
    @IBAction func registerToFB(_ sender: UIButton) {
        print("pressed register")
        registerNewUser()
    }
    
    func loginAnonymously() {
        FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
            
            if error != nil {
                print("Error attempting to log in anonymously: \(error!)")
            }
            if user != nil {
                print("Signed in anonymously!")
                
                self.shouldPerformSegue(withIdentifier: self.segue, sender: self)
            }
        })
        
    }
    
    func loginUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("cannot validate username/password")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                if self.emailTextField.text?.characters.count == 0 {
                    let alertController = UIAlertController(title: "Incorrect email", message: "ex: example@gmail.com", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                if (self.passwordTextField.text?.characters.count)! < 6 {
                    let alertController = UIAlertController(title: "Incorrect password", message: "Password should be at least 6 characters", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Nonexistant user", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            
            if user != nil {
                //segue to other controller
                self.currentUserUid = FIRAuth.auth()?.currentUser?.uid
                
                print("signed in \(FIRAuth.auth()?.currentUser?.uid), as \(FIRAuth.auth()?.currentUser?.email)")
                let alertController = UIAlertController(title: "Login Successful", message: nil, preferredStyle: .alert)
                let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defautAction)
                self.present(alertController, animated: true, completion: nil)
                
                self.shouldPerformSegue(withIdentifier: self.segue, sender: self)
                
            } else {
                let alertController = UIAlertController(title: "Login Failed!", message: "Incorrect email or password", preferredStyle: .alert)
                let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defautAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
    }
    
    func registerNewUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("cannot validate username/password")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print("error adding user \(error)")
                // Error Messages
                if !(self.emailTextField.text?.contains("@"))!{
                    let alertController = UIAlertController(title: "Incorrect email", message: nil, preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Successfully registered new user!", message: "Welcome slave..", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    //automatically login user:
                    FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: nil)
                }
                return
            }
        })
    }
    
}
