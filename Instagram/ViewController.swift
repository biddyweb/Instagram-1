//
//  ViewController.swift
//  Instagram
//
//  Created by Rustan Corpuz on 12/5/14.
//  Copyright (c) 2014 Rustan Corpuz Software Lab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var activityIndicator:UIActivityIndicatorView!
    var error = ""
    //    var signupActive = true
    
    @IBAction func signUp(sender: AnyObject) {
        
        if validateTextFields() {
            signUp()
        }
        
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if validateTextFields() {
            logIn()
        }
    }
    
    
    //Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("jumpToUserTable", sender: self)
        }
    }
    
    

    //Parse Helper Methods
    
    func signUp() {
        var user = PFUser()
        user.username =  username.text
        user.password = password.text
        
        displayActivityIndicator()
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, signupError: NSError!) -> Void in
            
            self.stopActivityIndicator()
            
            if signupError == nil {
                self.displayAlert(title: "Successfully Signed up", alertMessage: "")
            } else {
                if let errorString = signupError.userInfo?["error"] as? NSString {
                    self.error = errorString
                }else{
                    self.error = "Something is wrong"
                }
                // Show the errorString somewhere and let the user try again.
                self.displayAlert(title: "Could not sign up", alertMessage: self.error)
            }
        }
    }
    
    func logIn(){
        
        displayActivityIndicator()
        
        PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
            (user: PFUser!, loginError: NSError!) -> Void in
            
            self.stopActivityIndicator()
            
            if user != nil {
                // Do stuff after successful login.
                self.displayAlert(title: "Successfully logged in", alertMessage: "")
            } else {
                if let errorString = loginError.userInfo?["error"] as? NSString {
                    self.error = errorString
                }else{
                    self.error = "Something is wrong"
                }
                // Show the errorString somewhere and let the user try again.
                self.displayAlert(title: "Could not log in", alertMessage: self.error)
            }
        }
    }
    
    //Custom Helper Methods
    
    func displayAlert(#title:String, alertMessage:String){
        
        var alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayActivityIndicator(){
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(){
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    
    func validateTextFields() -> Bool{
        if username.text == "" || password.text == "" {
            error = "Please enter username and password"
            displayAlert(title: "Error in form", alertMessage: error)
            return false
        }else{
            return true
        }
    }
    
    
}

