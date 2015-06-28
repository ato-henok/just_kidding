//
//  SettingViewController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 6/27/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse

class SettingViewController: UIViewController{

   
    @IBOutlet var changeBio: UIButton! = UIButton()
    
    @IBOutlet var changePassword: UIButton! = UIButton()
    
    @IBOutlet var changeUsername: UIButton! = UIButton()
    
    @IBOutlet var changeEmail: UIButton! = UIButton()
    
    @IBOutlet var stageNot: UISwitch! = UISwitch()
    
    @IBOutlet var logout: UIButton! = UIButton()
    
    
    override func viewDidAppear(animated: Bool) {
        
        changeBio.addTarget(self, action: "changeBioCliked:", forControlEvents: .TouchUpInside)
        changePassword.addTarget(self, action: "changePasswordClicked:", forControlEvents: .TouchUpInside)
        changeUsername.addTarget(self, action: "changeUsernameClicked:", forControlEvents: .TouchUpInside)
        changeEmail.addTarget(self, action: "changeEmailClicked:", forControlEvents: .TouchUpInside)
        logout.addTarget(self, action: "logoutClicked:", forControlEvents: .TouchUpInside)
        
    }
    
    func changeBioClicked(sender: UIButton!){
        
        var changeBioAlert:UIAlertController = UIAlertController(title: "Bio", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        changeBioAlert.addTextFieldWithConfigurationHandler({
            textField in
            
            textField.placeholder = "Say something badass about yourself"
        })
        
        changeBioAlert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: { alertAction in
            
            let textFields:NSArray = changeBioAlert.textFields! as NSArray
            
            let bioTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
            var currentUser = PFUser.currentUser()
            
            currentUser?.setValue(bioTextField.text, forKey: "aboutMe")
            currentUser?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    
                    println("Bio updated!")
                    
                }else{
                    
                    println("Bio was not updated.")
                    
                }
                
            })
            
            
            
            
        }))
        
        changeBioAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { alertAction in
            println("Cancel button pressed");
            
        }))
        
        // Present the controller
        self.presentViewController(changeBioAlert, animated: true, completion: nil)
        
    }
    
    
    
    
    func changePasswordClicked(sender: UIButton!){
        
        PFUser.requestPasswordResetForEmailInBackground(PFUser.currentUser()!.email!, block: { (success:Bool, error:NSError?) -> Void in
            if(error == nil){
                var alert = UIAlertView(title: "Password Reset", message: "Password reset link has been sent to your email!", delegate: nil, cancelButtonTitle: "Aight")
                alert.show()
                println("Password Reset Link Sent!")
            }else{
                println("Password Reset Link Not sent.")
            }
        })
        
    }
    
    func changeUsernameClicked(sender: UIButton!){
        
    }
    
    func changeEmailClicked(sender: UIButton!){
        
    }

    
    func logoutClicked(sender: UIButton!){
        
        PFUser.logOut()
        println("User logged out!")
        println("Current User:")
        println(PFUser.currentUser()?.username)
        println("***********")
        
    }
    

}

    
    


    

