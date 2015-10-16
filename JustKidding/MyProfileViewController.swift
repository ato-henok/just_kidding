//
//  MyProfileViewController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/19/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timelineData:NSMutableArray = NSMutableArray()
    var favArray:NSMutableArray = NSMutableArray()
    
    //var jokeObj:PFObject = PFObject()
    var jokeObj = PFObject(className: "Jokes")
    
    @IBOutlet var notifyBtn: UIButton! = UIButton()
    
    @IBOutlet var usernameLabel: UILabel! = UILabel()
    
    @IBOutlet var bioLabel: UILabel! = UILabel()
  
    
    @IBOutlet var tableView: UITableView!
    
    
    
    // Load
    
    func loadFavData(){
        // Initially, remove what is already there
        self.timelineData.removeAllObjects()
        let relation = PFUser.currentUser()!.relationForKey("favoriteJokes") as PFRelation
        let query = relation.query()
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("\(objects!.count) favorite jokes on profile")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.timelineData.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
        
    }
    
    func loadEntriesData(){
        // Initially, remove what is already there
        if(PFUser.currentUser() != nil){
            
        
        self.timelineData.removeAllObjects()
        let relation = PFUser.currentUser()!.relationForKey("userJokes") as PFRelation
        let query = relation.query()
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("\(objects!.count) entries on profile")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.timelineData.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error) \(error!.userInfo)")
            }
        }
            
        }
        
        
    }
    
    
    
    
    func loadFavs(){
        self.favArray.removeAllObjects()
        
        let relation = PFUser.currentUser()!.relationForKey("favoriteJokes") as PFRelation
        
        let query:PFQuery = relation.query()!
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("\(objects!.count) user favorites.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.favArray.addObject(object.objectId!)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
    }
    
    @IBAction func myProfileToggle(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            // Load entries
            self.loadEntriesData()
        }else if(sender.selectedSegmentIndex == 1){
            // Load favorites
            self.loadFavData()
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
                        self.loadEntriesData()
                        self.usernameLabel.text = PFUser.currentUser()!.username
                        self.bioLabel.text = (PFUser.currentUser()!.objectForKey("aboutMe") as? String)
                        
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
                        self.loadEntriesData()
                        self.usernameLabel.text = PFUser.currentUser()!.username
                        self.bioLabel.text = (PFUser.currentUser()!.objectForKey("aboutMe") as? String)
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
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:155.0/255.0, green:89.0/255.0,blue:182.0/255.0,alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        PFUser.currentUser()?.fetch()
        
        if(PFUser.currentUser() != nil){
        
            
            
                self.loadEntriesData()
                
                self.loadFavs()
        
            
            
            
                let jksOnStage = PFUser.currentUser()!.objectForKey("jokesOnStage") as! Int?
            
                print(jksOnStage)
            
                if(jksOnStage != nil){
                
                    if(jksOnStage > 0){
                        self.usernameLabel.text = "\(PFUser.currentUser()!.username!) [\(String(jksOnStage!)) times on stage]"
                    }
                    
                }else{
                    
                    self.usernameLabel.text = PFUser.currentUser()!.username
                }

            
            
                self.bioLabel.text = (PFUser.currentUser()!.objectForKey("aboutMe") as? String)
            
            
            //ADMIN
             if(PFUser.currentUser()!.objectForKey("isAdmin")?.boolValue == true){
                
                self.notifyBtn.addTarget(self, action: "notifyBtnCLicked:", forControlEvents: .TouchUpInside)
                
            }
            
            
        
        }else{
            
           
            
            signinUser()
            self.loadEntriesData()
            
        }
    }

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(ProfileCell.self, forCellReuseIdentifier: "groupcell")
        
        //ADMIN
        
        if(PFUser.currentUser() != nil){
            if(PFUser.currentUser()!.objectForKey("isAdmin")?.boolValue == true){
                
                self.notifyBtn.hidden = false
                
            }else{
                
                self.notifyBtn.hidden = true
            }
            
            
        }else{
            self.notifyBtn.hidden = true
        }
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ProfileCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ProfileCell
        
        let joke:PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.jokeLabel.text = joke.objectForKey("joke") as? String
        
        //****************COLOR CODE*********
        if(joke.objectForKey("fromAdmin")?.boolValue == true){
            //cell.jokeLabel.textColor = UIColor(red:155.0/255.0, green:89.0/255.0,blue:182.0/255.0,alpha:1.0)
            cell.jokeLabel.backgroundColor = UIColor(red:220.0/255.0, green:182.0/255.0,blue:222.0/255.0,alpha:1.0)
        }
        //********************
        
        cell.usernameLabel.text = joke.objectForKey("senderName") as? String
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        cell.dateLabel.text = dateFormatter.stringFromDate(joke.createdAt!)
        
        let likesArray = joke.objectForKey("likersArray") as! NSArray
        let dislikesArray = joke.objectForKey("dislikersArray") as! NSArray
        
        let net = likesArray.count - dislikesArray.count
        
        cell.counterLabel.text = String(net)
        
        let currentUser = PFUser.currentUser()
        
        let rose_selected = UIImage(named: "rose_selected.png") as UIImage!
        let rose_empty = UIImage(named: "rose_empty.png") as UIImage!
        let tomato_selected = UIImage(named: "tomato_selected.png") as UIImage!
        let tomato_empty = UIImage(named: "tomato_empty.png") as UIImage!
        let fav_empty = UIImage(named: "favorite_empty.png") as UIImage!
        let fav_selected = UIImage(named: "favorite_selected.png") as UIImage!
        
        // Update the Like and Dislike icons
        
        if(likesArray.containsObject(currentUser!.objectId!)){
            
            cell.roseBtn.setBackgroundImage(rose_selected, forState: UIControlState.Normal)
            cell.tomatoBtn.setBackgroundImage(tomato_empty, forState: .Normal)
        }else if(dislikesArray.containsObject(currentUser!.objectId!)){
            cell.tomatoBtn.setBackgroundImage(tomato_selected, forState: .Normal)
            cell.roseBtn.setBackgroundImage(rose_empty, forState: .Normal)
        }else{
            cell.roseBtn.setBackgroundImage(rose_empty, forState: .Normal)
            cell.tomatoBtn.setBackgroundImage(tomato_empty, forState: .Normal)
        }
        
        // Update favorite icon
        
        if(self.favArray.containsObject(joke.objectId!)){
            cell.favBtn.setBackgroundImage(fav_selected, forState: .Normal)
        }else{
            cell.favBtn.setBackgroundImage(fav_empty, forState: .Normal)
        }
        
        
        
        // Rose button clicked
        cell.roseBtn.tag = indexPath.row
        cell.roseBtn.addTarget(self, action: "roseBtnClicked:", forControlEvents: .TouchUpInside)
        
        // Tomato button clicked
        cell.tomatoBtn.tag = indexPath.row
        cell.tomatoBtn.addTarget(self, action: "tomatoBtnClicked:", forControlEvents: .TouchUpInside)
        
        // Favorite button clicked
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: "favBtnClicked:", forControlEvents: .TouchUpInside)
        
        
        //ADMIN
        
        if(currentUser != nil){
            
            
            if(currentUser!.objectForKey("isAdmin")?.boolValue == true){
                
                cell.flagsLabel.text = (joke.objectForKey("redFlags"))!.stringValue
                
                // Ban button clicked
                cell.banBtn.tag = indexPath.row;
                cell.banBtn.addTarget(self, action: "banBtnClicked:", forControlEvents: .TouchUpInside)
                
                // Delete button clicked
                cell.delBtn.tag = indexPath.row;
                cell.delBtn.addTarget(self, action: "delBtnClicked:", forControlEvents: .TouchUpInside)
                
                // Feature button clicked
                cell.ftBtn.tag = indexPath.row;
                cell.ftBtn.addTarget(self, action: "ftBtnClicked:", forControlEvents: .TouchUpInside)
                
                
                
                
            }else{
                cell.flagsLabel.hidden = true;
                cell.banBtn.hidden = true;
                cell.delBtn.hidden = true;
                cell.ftBtn.hidden = true;
            }
            
        }
        
        //ADMIN
    
        
        
        return cell
    }
    
    //########################################################
    //functions for Like, Dislke, and Favorite buttons
    
    func roseBtnClicked(sender: UIButton!) {
        
        let joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        
        let likersArray = joke.objectForKey("likersArray") as! NSArray
        
        let objectId:NSString = PFUser.currentUser()!.objectId!
        if(!(likersArray.containsObject(objectId))){
            
            joke.addObject(objectId, forKey: "likersArray")
            joke.removeObject(objectId, forKey: "dislikersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("_Rose saved")
                }else{
                    print("_Rose error")
                }
                
            })
            
        }else if((likersArray.containsObject(objectId))){
            
            joke.removeObject(objectId, forKey: "likersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("_Rose saved")
                }else{
                    print("_Rose error")
                }
                
            })
            
        }
        self.tableView.reloadData()
    }
    
    func tomatoBtnClicked(sender: UIButton!) {
        
        print("Tomato Btn Clicked")
        
        let joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        let dislikersArray = joke.objectForKey("dislikersArray") as! NSArray
        
        let objectId:NSString = PFUser.currentUser()!.objectId!
        
        if(!(dislikersArray.containsObject(objectId))){
            joke.addObject(objectId, forKey: "dislikersArray")
            joke.removeObject(objectId, forKey: "likersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("Tomato saved")
                }else{
                    print("Tomato error")
                }
                
            })
        }else if((dislikersArray.containsObject(objectId))){
            joke.removeObject(objectId, forKey: "dislikersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("_Tomato saved")
                }else{
                    print("_Tomato error")
                }
                
            })
        }
        self.tableView.reloadData()
    }
    
    func favBtnClicked(sender: UIButton!) {
        
        print("Favorite Btn Clicked")
        
        
        let joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        let jokeObjectId = joke.objectId
        
        let relation = PFUser.currentUser()!.relationForKey("favoriteJokes") as PFRelation
        
        // Check if the joke is already in favorited
        
        if(self.favArray.containsObject(jokeObjectId!)){
            relation.removeObject(joke)
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("_Joke un-favorited")
                }else{
                    print("_Un-favorite error")
                }
            })
            
        }else{
            relation.addObject(joke)
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("_Joke favorited")
                    
                }else{
                    print("_Favorite error")
                }
            })
        }
        
        self.tableView.reloadData()
    }
    
    
    //########################################################
    
    
    
    
    //************ Admin Functions **********
    func banBtnClicked(sender: UIButton!) {
        
        let confirmationAlert = UIAlertController(title: "Are you sure?", message: "User will be banned permanently", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction) in
            
            let joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
            
            let authorId = joke.objectForKey("senderId") as! String
            let author = PFUser()
            author.objectId = authorId
            
            author.deleteInBackgroundWithBlock { (bool:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    print("User banned!")
                }
            }
            
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
            
            print("User not banned")
            
        }))
        
        presentViewController(confirmationAlert, animated: true, completion: nil)
        
        
        self.tableView.reloadData()
    }
    
    
    func delBtnClicked(sender: UIButton!) {
        
        let confirmationAlert = UIAlertController(title: "Are you sure?", message: "Joke will be deleted permanently", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction) in
            
            let joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
            
            joke.deleteInBackgroundWithBlock { (bool:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    print("Joke deleted!")
                }
            }
            
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
            
            print("Joke not deleted")
            
        }))
        
        presentViewController(confirmationAlert, animated: true, completion: nil)
        
        
        self.tableView.reloadData()
    }
    
    
    func ftBtnClicked(sender: UIButton!) {
        
       
        let joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        
        if(joke.objectForKey("isOnStage")! as! NSObject == false){
            
            sender.titleLabel?.text = "Un-Ft"
            joke.setValue(true, forKey: "isOnStage")
            
            let todaysDate:NSDate = NSDate()
            joke.setValue(todaysDate, forKey: "featuredAt")
            
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("Joke FEATURED!")
                    
                    //Send push notification to author
                    
                    
                    let  query = PFUser.query()
                    query?.whereKey("objectId", equalTo: joke.objectForKey("senderId")!)
                    query?.getFirstObjectInBackgroundWithBlock({ (author, error) -> Void in
                        
                        if error == nil {
                            
                            print("Query returned user to be featured")
                            
                            let pushQuery:PFQuery = PFInstallation.query()!
                            pushQuery.whereKey("user", equalTo: author!)
                            let push:PFPush = PFPush()
                            push.setQuery(pushQuery)
                            
                            //push.setChannel("youreOnStage")
                            print("Check1")
                            push.setMessage("Congrats! You are featured on the Stage!")
                            
                            push.sendPushInBackgroundWithBlock({ (bool, error) -> Void in
                                if(error == nil){
                                    print("Congrats push sent")
                                }else{
                                    print("Error sending congrats push")
                                }
                            })
                            
                            
                        }else{
                            print("Error querying author")
                        }
                    })
                    
                    
                    
                    
                }else{
                    print("Error occured while featuring")
                }
            })
            
        }else{
            
            sender.titleLabel?.text = "Ft"
            joke.setValue(false, forKey: "isOnStage")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    print("Joke UN-FEATURED!")
                }else{
                    print("Error occured un-featuring")
                }
            })
            
            
        }
        self.tableView.reloadData()
    }

    
    //************
    
    
    func notifyBtnCLicked(sender: UIButton!){
        
        self.notifyBtn.hidden = false
        
        //Send push notification to all users that there is new content on Stage
        
        let pushQuery:PFQuery = PFInstallation.query()!
        pushQuery.whereKey("channels", equalTo: "newJokes")
        let push:PFPush = PFPush()
        push.setQuery(pushQuery)
        
        print("Check1")
        push.setMessage("New jokes on Stage")
        
        push.sendPushInBackgroundWithBlock({ (bool, error) -> Void in
            if(error == nil){
                print("New jokes push sent")
            }else{
                print("Error sending mew jokes push")
            }
        })
        
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showComments" {
            
            let controller = segue.destinationViewController as! CommentsViewController
            controller.commentEntry = self.jokeObj
            
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.jokeObj = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        self.performSegueWithIdentifier("showComments", sender: self)
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let currentuser = PFUser.currentUser()
        let joke = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        if(joke.objectForKey("senderId") as? NSString == currentuser!.objectId){
            
            let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
                print("Delete button tapped")
                
                if(currentuser != nil){
                    
                    
                    joke.deleteInBackgroundWithBlock({ (bool, error) -> Void in
                        
                        if(error == nil){
                            print("User joke deleted!")
                            self.loadEntriesData()
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
                
                let joke = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
                
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
