//
//  TimelineTableViewController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/15/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse

class TimelineTableViewController: UIViewController {
    /*
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        if(PFUser.currentUser() == nil){
            
            //###########################################################################
            // Alert for Signing up or loggin in
            
            var alert:UIAlertController = UIAlertController(title: "Welcome", message: "You need to signup or login in order to post", preferredStyle: UIAlertControllerStyle.Alert)
            

            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                
                //********************************************************************
                
                var loginAlert:UIAlertController = UIAlertController(title: "Login", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                // Username textfield created with placeholder
                loginAlert.addTextFieldWithConfigurationHandler({
                    
                    textfield in
                    textfield.placeholder = "Username"
                    
                })
                
                // Password textfield created with placeholder
                loginAlert.addTextFieldWithConfigurationHandler({
                    
                    textfield in
                    textfield.placeholder = "Password"
                    textfield.secureTextEntry = true
                    
                })
                
                // Action for Login button
                loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                    alertAction in
                    
                    let textFields:NSArray = loginAlert.textFields! as NSArray
                    
                    let usernameTextField:UITextField = textFields.objectAtIndex(0) as UITextField
                    let passwordTextField:UITextField = textFields.objectAtIndex(1) as UITextField
                    
                    PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text){ (user:PFUser!, error:NSError!) -> Void in
                        
                        if((user) != nil){
                            println("Login success!")
                        }else{
                            println(error)
                        }
                        
                        
                        
                    }
                    
                }))
                self.presentViewController(loginAlert, animated: true, completion: nil)
                //********************************************************************
                
                
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Signup", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                //********************************************************************
                var signupAlert:UIAlertController = UIAlertController(title: "New Account", message: "Enter the following info to signup", preferredStyle: UIAlertControllerStyle.Alert)
                
                // Email textfield created with placeholder
                signupAlert.addTextFieldWithConfigurationHandler({
                    
                    textfield in
                    textfield.placeholder = "Email"
                    
                })
                
                // Username textfield created with placeholder
                signupAlert.addTextFieldWithConfigurationHandler({
                    
                    textfield in
                    textfield.placeholder = "Username"
                    
                })
                
                // Password textfield created with placeholder
                signupAlert.addTextFieldWithConfigurationHandler({
                    
                    textfield in
                    textfield.placeholder = "Password"
                    textfield.secureTextEntry = true
                    
                })
                
                
                // Action for Login button
                signupAlert.addAction(UIAlertAction(title: "Signup", style: UIAlertActionStyle.Default, handler: {
                    alertAction in
                    
                    let textFields:NSArray = signupAlert.textFields! as NSArray
                    
                    let emailTextField:UITextField = textFields.objectAtIndex(0) as UITextField
                    let usernameTextField:UITextField = textFields.objectAtIndex(1) as UITextField
                    let passwordTextField:UITextField = textFields.objectAtIndex(2) as UITextField
                    
                    
                    var newUser:PFUser = PFUser()
                    newUser.email = emailTextField.text
                    newUser.username = usernameTextField.text
                    newUser.password = passwordTextField.text
                    newUser["aboutMe"] = "Say something badass about yourself"
                    newUser.signUpInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                        if(success){
                            println("New user created")
                        }else{
                            println(error)
                        }
                    })
                    
                }))
                self.presentViewController(signupAlert, animated: true, completion: nil)
                //********************************************************************
                
                
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
            //###########################################################################
            
            
            
      
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
