//
//  PostViewController.swift
//  Instagram
//
//  Created by Rustan Corpuz on 12/7/14.
//  Copyright (c) 2014 Rustan Corpuz Software Lab. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var shareText: UITextField!
    
    var photoSelected:Bool = false
    var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var photoSelected:Bool = false
        imageToPost.image = UIImage(named: "man-placeholder")
        shareText.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    func displayAlert(#title:String, alertMessage:String){
        
        var alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            action in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
        photoSelected = true
    }
    
    func displayActivityIndicator(){
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        view.addSubview(activityIndicator)
        self.view.superview?.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(){
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBAction func postImage(sender: AnyObject) {
        
        var error:String = ""
        
        if !photoSelected{
            error = "Please select an image to post"
        }else if shareText.text.isEmpty{
            error = "Please enter a message"
        }
        
        if !error.isEmpty {
            displayAlert(title: "Error in form", alertMessage: error)
        }else{
            
            var post = PFObject(className: "Post")
            post["title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            
            self.displayActivityIndicator()
            
            post.saveInBackgroundWithBlock({ (success: Bool, saveError: NSError!) -> Void in
                
                self.stopActivityIndicator()
                if !success {
                    self.displayAlert(title: "Could not post image", alertMessage: "Please try again later")
                }else{
                    let imageData = UIImageJPEGRepresentation(self.imageToPost.image, 1.0)
                    let imageFile = PFFile(name: "\(PFUser.currentUser().username)-image.jpg", data: imageData)
                    
                    post["imagefile"] = imageFile
                    post.saveInBackgroundWithBlock({ (success: Bool, saveError: NSError!) -> Void in
                        self.stopActivityIndicator()
                        
                        if !success{
                            self.displayAlert(title: "Could not post image", alertMessage: "Please try again")
                        }else{
                            
                            self.displayAlert(title: "Successfully posted image", alertMessage: "")
                            self.photoSelected = false
                            self.shareText.text = ""
                            self.imageToPost.image = UIImage(named: "man-placeholder")
                            
                        }
                    })
                }
                
                
            })
        }
        
        
    }
    
    
}
