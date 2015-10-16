
//
//  CommentsViewController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/17/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse
import iAd

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate {
    
    @IBOutlet var adBannerView: ADBannerView?
    
    @IBOutlet var tableView: UITableView!
    
    var commentsArray:NSMutableArray = NSMutableArray()
    //var favArray:NSArray = NSArray()
    
    var commentEntry = PFObject(className: "Comments")
    
    // Load
    func loadData(){
        // Initially, remove what is already there
        self.commentsArray.removeAllObjects()
        
        let relation:PFRelation = self.commentEntry.relationForKey("associatedComments")
        let query:PFQuery = relation.query()!
        query.orderByDescending("likersArray")

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("\(objects!.count) comments.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.commentsArray.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
        
    }
    
    //?????????
    func signinUser(){
        
        //###########################################################################
        // Alert for Signing up or loggin in
        
        let alert:UIAlertController = UIAlertController(title: "Welcome", message: "You need to signup or login in order to interact", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            
            //********************************************************************
            
            let loginAlert:UIAlertController = UIAlertController(title: "Login", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
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
                
                PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!){ (user:PFUser?, error:NSError?) -> Void in
                    
                    if((user) != nil){
                        print("Login success!")
                    }else{
                        print(error)
                        let errorAlert:UIAlertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        errorAlert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                            
                            self.presentViewController(loginAlert, animated: true, completion: nil)
                            
                        }))
                        
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                    }
                    
                    
                    
                }
                
            }))
            self.presentViewController(loginAlert, animated: true, completion: nil)
            //********************************************************************
            
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Signup", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            //********************************************************************
            let signupAlert:UIAlertController = UIAlertController(title: "New Account", message: "Enter the following info to signup", preferredStyle: UIAlertControllerStyle.Alert)
            
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
                
                
                let newUser:PFUser = PFUser()
                newUser.email = emailTextField.text
                newUser.username = usernameTextField.text
                newUser.password = passwordTextField.text
                newUser["aboutMe"] = "Say something badass about yourself"
                newUser.setValue(false, forKey: "isAdmin")
                newUser.signUpInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                    if(success){
                        print("New user created")
                    }else{
                        print(error)
                        let errorAlert:UIAlertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        errorAlert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                            
                            self.presentViewController(signupAlert, animated: true, completion: nil)
                            
                        }))
                        
                        self.presentViewController(errorAlert, animated: true, completion: nil)
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
        
        self.canDisplayBannerAds = true
        self.adBannerView?.delegate = self
        self.adBannerView?.hidden = true
        
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
        
        PFUser.currentUser()?.fetch()
        
        if(PFUser.currentUser() == nil){
            
            
            signinUser()
            
        
        }else{
            
            
        let addCommentAlert:UIAlertController = UIAlertController(title: "Comment", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        addCommentAlert.addTextFieldWithConfigurationHandler({
            textField in
            
            textField.placeholder = "Say something nice...jk"
        })
        
        addCommentAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { alertAction in
            
            let textFields:NSArray = addCommentAlert.textFields! as NSArray
            
            let commentTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
            
            
            
            if((commentTextField.text! as NSString).length > 140 || (commentTextField.text! as NSString).length == 0){
                
                let alert = UIAlertView(title: "Oops!", message: "Comment has to be less than 140 characters and cannot be empty.", delegate: nil, cancelButtonTitle: "Go it!")
                alert.show();
                
            }else{
            
            let newComment:PFObject = PFObject(className: "Comments")
            newComment["comment"] = commentTextField.text
            newComment["commenterId"] = PFUser.currentUser()!.objectId
                
            //****************COLOR CODE*********
            if(PFUser.currentUser()!.objectForKey("isAdmin")?.boolValue == true){
                    newComment["fromAdmin"] = true
            }
            //********************
                
            newComment["commenterName"] = 	PFUser.currentUser()!.username
            newComment["likersArray"] = []
            newComment["redFlags"] = 0
            newComment.saveInBackgroundWithBlock({ (sucess:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    
                    let relation = self.commentEntry.relationForKey("associatedComments") as PFRelation
                    relation.addObject(newComment)
                    self.commentEntry.saveInBackgroundWithBlock({ (sucess:Bool, error:NSError?) -> Void in
                        
                        if(error == nil){
                              //self.tableView.reloadData()
                              print("New comment related and saved")
                              self.loadData()   
                            
                        }else{
                           
                            print("Error relating new comment")
                        }
                    })
                    
                   
                }else{
                    print("Error with new comment")
                }
                
            })
            self.tableView.reloadData()
                
                
            }//end for 140 if
            
            
        }))
        
        addCommentAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { alertAction in
            print("Cancel button pressed");
            
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
        
        //****************COLOR CODE*********
        if(comment.objectForKey("fromAdmin")?.boolValue == true){
            //cell.jokeLabel.textColor = UIColor(red:155.0/255.0, green:89.0/255.0,blue:182.0/255.0,alpha:1.0)
            cell.commentLabel.backgroundColor = UIColor(red:220.0/255.0, green:182.0/255.0,blue:222.0/255.0,alpha:1.0)
        }
        //********************
        
        cell.usernameLabel.text = (comment.objectForKey("commenterName") as! String)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        cell.dateLabel.text = dateFormatter.stringFromDate(comment.createdAt!) as String

        let likesArray = comment.objectForKey("likersArray") as! NSArray
        
        cell.likesLabel.text = String(likesArray.count)
        
        let like_selected = UIImage(named: "like_selected.png") as UIImage!
        let like_empty = UIImage(named: "like_empty.png") as UIImage!
        
        let likersArray = comment.objectForKey("likersArray") as! NSArray
        
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
        
        print("Like Btn Clicked")
        
        
        if(PFUser.currentUser() == nil){
            
            
            signinUser()
            
            
        }else{
        
        let comment = self.commentsArray.objectAtIndex(sender.tag) as! PFObject
        let likersArray = comment.objectForKey("likersArray") as! NSArray
        
        if(likersArray.containsObject(PFUser.currentUser()!.objectId!)){
            comment.removeObject(PFUser.currentUser()!.objectId!, forKey: "likersArray")
        }else{
            comment.addObject(PFUser.currentUser()!.objectId!, forKey: "likersArray")
        }
        
        comment.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
            if(error == nil){
                print("_Like saved")
            }else{
                print("_Like error")
            }
            
        })
        self.tableView.reloadData()
            
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let currentuser = PFUser.currentUser()
        let joke = self.commentsArray.objectAtIndex(indexPath.row) as! PFObject
        
        if(joke.objectForKey("commenterId") as? NSString == currentuser!.objectId){
            
            let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
                print("Delete button tapped")
                
                if(currentuser != nil){
                    
                    
                    joke.deleteInBackgroundWithBlock({ (bool, error) -> Void in
                        
                        if(error == nil){
                            print("User joke deleted!")
                            self.loadData()
                        }else{
                            print("Error deleting joke")
                        }
                        
                    })
                }
            }
            
            delete.backgroundColor = UIColor.redColor()
            
            return [delete]
        }
        
        
        let flag = UITableViewRowAction(style: .Normal, title: "Flag") { action, index in
            print("Flag button tapped")
            
            if(currentuser != nil){
                
                let joke = self.commentsArray.objectAtIndex(indexPath.row) as! PFObject
                
                joke.incrementKey("redFlags")
                joke.saveInBackgroundWithBlock({ (bool, error) -> Void in
                    if(error == nil){
                        print("Joke flagged!")
                    }else{
                        print("Error flagging joke")
                    }
                })
            }
            
            
            
        }
        flag.backgroundColor = UIColor.orangeColor()
        
        
        return [flag]
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }

    
    //ADS: import, delegate, viewDidLOAD
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.adBannerView?.hidden = false
    }
    
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
    
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.adBannerView?.hidden = true
    }
    
    //########################################################

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
