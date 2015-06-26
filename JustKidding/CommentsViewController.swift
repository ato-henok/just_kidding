
//
//  CommentsViewController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/17/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var commentsArray:NSMutableArray = NSMutableArray()
    //var favArray:NSArray = NSArray()
    
    var commentEntry = PFObject(className: "Comments")
    
    // Load
    func loadData(){
        // Initially, remove what is already there
        self.commentsArray.removeAllObjects()
        
        var relation:PFRelation = self.commentEntry.relationForKey("associatedComments")
        var query:PFQuery = relation.query()!
        query.orderByDescending("likersArray")

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects!.count) comments.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.commentsArray.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
            }
        }
        
        
    }
    
    //?????????
    func signinUser(){
        
        //###########################################################################
        // Alert for Signing up or loggin in
        
        var alert:UIAlertController = UIAlertController(title: "Welcome", message: "You need to signup or login in order to interact", preferredStyle: UIAlertControllerStyle.Alert)
        
        
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
                
                let usernameTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
                let passwordTextField:UITextField = textFields.objectAtIndex(1)as! UITextField
                
                PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text){ (user:PFUser?, error:NSError?) -> Void in
                    
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
                
                let emailTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
                let usernameTextField:UITextField = textFields.objectAtIndex(1)as! UITextField
                let passwordTextField:UITextField = textFields.objectAtIndex(2) as! UITextField
                
                
                var newUser:PFUser = PFUser()
                newUser.email = emailTextField.text
                newUser.username = usernameTextField.text
                newUser.password = passwordTextField.text
                newUser["aboutMe"] = "Say something badass about yourself"
                newUser.signUpInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
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
    //??????????????
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Call the data loader
        self.loadData()
        
        //self.favArray = self.commentEntry.objectForKey("likersArray") as NSArray
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(CommentCell.self, forCellReuseIdentifier: "groupcell")
        
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addComment(sender: AnyObject) {
        
        
        if(PFUser.currentUser() == nil){
            
            
            signinUser()
            
            
        }else{
            
            
        var addCommentAlert:UIAlertController = UIAlertController(title: "Comment", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        addCommentAlert.addTextFieldWithConfigurationHandler({
            textField in
            
            textField.placeholder = "Say something nice...jk"
        })
        
        addCommentAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { alertAction in
            
            let textFields:NSArray = addCommentAlert.textFields! as NSArray
            
            let commentTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
            
            var newComment:PFObject = PFObject(className: "Comments")
            newComment["comment"] = commentTextField.text
            newComment["commenterId"] = PFUser.currentUser()!.objectId
            newComment["commenterName"] = 	PFUser.currentUser()!.username
            newComment["likersArray"] = []
            newComment["redFlags"] = 0
            newComment.saveInBackgroundWithBlock({ (sucess:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    
                    var relation = self.commentEntry.relationForKey("associatedComments") as PFRelation
                    relation.addObject(newComment)
                    self.commentEntry.saveInBackgroundWithBlock({ (sucess:Bool, error:NSError?) -> Void in
                        
                        if(error == nil){
                              self.tableView.reloadData()
                              println("New comment related and saved")
                              self.loadData()
                            
                        }else{
                           
                            println("Error relating new comment")
                        }
                    })
                    
                   
                }else{
                    println("Error with new comment")
                }
                
            })
            self.tableView.reloadData()
            
            
            
        }))
        
        addCommentAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { alertAction in
            println("Cancel button pressed");
            
        }))
        
        // Present the controller
        self.presentViewController(addCommentAlert, animated: true, completion: nil)
            
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CommentCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CommentCell
        
        let comment:PFObject = self.commentsArray.objectAtIndex(indexPath.row) as! PFObject
        
        cell.commentLabel.text = comment.objectForKey("comment") as? String
      
        cell.usernameLabel.text = (comment.objectForKey("commenterName") as! String)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        cell.dateLabel.text = dateFormatter.stringFromDate(comment.createdAt!) as String

        var likesArray = comment.objectForKey("likersArray") as! NSArray
        
        cell.likesLabel.text = String(likesArray.count)
        
        let like_selected = UIImage(named: "like_selected.png") as UIImage!
        let like_empty = UIImage(named: "like_empty.png") as UIImage!
        
        var likersArray = comment.objectForKey("likersArray") as! NSArray
        
        if(PFUser.currentUser() != nil){
        
        if(likersArray.containsObject(PFUser.currentUser()!.objectId!)){
            cell.likeBtn.setBackgroundImage(like_selected, forState: .Normal)
        }else{
            cell.likeBtn.setBackgroundImage(like_empty, forState: .Normal)
        }
            
        }
        
        // Like button clicked
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: "likeBtnClicked:", forControlEvents: .TouchUpInside)
        
        return cell
    }

    func likeBtnClicked(sender:UIButton!){
        
        println("Like Btn Clicked")
        
        
        if(PFUser.currentUser() == nil){
            
            
            signinUser()
            
            
        }else{
        
        var comment = self.commentsArray.objectAtIndex(sender.tag) as! PFObject
        var likersArray = comment.objectForKey("likersArray") as! NSArray
        
        if(likersArray.containsObject(PFUser.currentUser()!.objectId!)){
            comment.removeObject(PFUser.currentUser()!.objectId!, forKey: "likersArray")
        }else{
            comment.addObject(PFUser.currentUser()!.objectId!, forKey: "likersArray")
        }
        
        comment.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
            if(error == nil){
                println("_Like saved")
            }else{
                println("_Like error")
            }
            
        })
        self.tableView.reloadData()
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
