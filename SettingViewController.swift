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
        
        changeBio.addTarget(self, action: "changeBioClicked:", forControlEvents: .TouchUpInside)
        changePassword.addTarget(self, action: "changePasswordClicked:", forControlEvents: .TouchUpInside)
        changeUsername.addTarget(self, action: "changeUsernameClicked:", forControlEvents: .TouchUpInside)
        changeEmail.addTarget(self, action: "changeEmailClicked:", forControlEvents: .TouchUpInside)
        logout.addTarget(self, action: "logoutClicked:", forControlEvents: .TouchUpInside)
        
    }
    
    func changeBioClicked(sender: UIButton!){
        
        let changeBioAlert:UIAlertController = UIAlertController(title: "Bio", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        changeBioAlert.addTextFieldWithConfigurationHandler({
            textField in
            
            textField.placeholder = "Say something badass about yourself"
        })
        
        changeBioAlert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: { alertAction in
            
            let textFields:NSArray = changeBioAlert.textFields! as NSArray
            
            let bioTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
            
            if((bioTextField.text! as NSString).length == 0){
                
                let alert = UIAlertView(title: "Oops!", message: "Bio cannot be empty. Pretty sure there is something badass about you.", delegate: nil, cancelButtonTitle: "Ok, thanks!")
                alert.show()
                
                
            }else if ((bioTextField.text! as NSString).length > 140){
                let alert = UIAlertView(title: "Too Long!", message: "Bio is too long. Let's save that for your autobiography", delegate: nil, cancelButtonTitle: "Ok, whatever!")
                alert.show()
                
            }else{
            
            let currentUser = PFUser.currentUser()
            currentUser?.setValue(bioTextField.text, forKey: "aboutMe")
            currentUser?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    
                    print("Bio updated!")
                    
                }else{
                    
                    print("Bio was not updated.")
                    
                }
                
            })
                
            }//end for empty error
            
            
            
        }))
        
        changeBioAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { alertAction in
            print("Cancel button pressed");
            
        }))
        
        // Present the controller
        self.presentViewController(changeBioAlert, animated: true, completion: nil)
        
    }
    
    
    
    
    func changePasswordClicked(sender: UIButton!){
        
        if(PFUser.currentUser()?.objectForKey("emailVerified")?.boolValue == false){
            
                let alert = UIAlertView(title: "Verify Email", message: "Verify your email before you interact!", delegate: nil, cancelButtonTitle: "OKAY,FINE!")
                alert.show();
            
        }else{
            
            PFUser.requestPasswordResetForEmailInBackground(PFUser.currentUser()!.email!, block: { (success:Bool, error:NSError?) -> Void in
                if(error == nil){
                    let alert = UIAlertView(title: "Password Reset", message: "Password reset link has been sent to your email!", delegate: nil, cancelButtonTitle: "Aight")
                    alert.show()
                    print("Password Reset Link Sent!")
                }else{
                    print("Password Reset Link Not sent.")
                }
            })
            
        }
        
        
        
    }
    
    func changeUsernameClicked(sender: UIButton!){
        
    }
    
    func changeEmailClicked(sender: UIButton!){
        
    }

    
    func logoutClicked(sender: UIButton!){
        //
        PFUser.logOut()
        print("User logged out!")
        print("Current User:")
        print(PFUser.currentUser()?.username)
        print("***********")
        //self.performSegueWithIdentifier("showStageAfterLogout", sender: self)
        
    }
   
    

}

    
    


    

