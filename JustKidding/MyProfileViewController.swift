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
    
    @IBOutlet var usernameLabel: UILabel! = UILabel()
    @IBOutlet var bioLabel: UILabel! = UILabel()
  
    
    @IBOutlet var tableView: UITableView!
    
    
    
    // Load
    
    func loadFavData(){
        // Initially, remove what is already there
        self.timelineData.removeAllObjects()
        var relation = PFUser.currentUser()!.relationForKey("favoriteJokes") as PFRelation
        var query = relation.query()
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects!.count) favorite jokes on profile")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.timelineData.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
            }
        }
        
        
    }
    
    func loadEntriesData(){
        // Initially, remove what is already there
        if(PFUser.currentUser() != nil){
            
        
        self.timelineData.removeAllObjects()
        var relation = PFUser.currentUser()!.relationForKey("userJokes") as PFRelation
        var query = relation.query()
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects!.count) entries on profile")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.timelineData.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
            }
        }
            
        }
        
        
    }
    
    
    
    
    func loadFavs(){
        self.favArray.removeAllObjects()
        
        var relation = PFUser.currentUser()!.relationForKey("favoriteJokes") as PFRelation
        
        var query:PFQuery = relation.query()!
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects!.count) user favorites.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.favArray.addObject(object.objectId!)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
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
                        self.loadEntriesData()
                        self.usernameLabel.text = PFUser.currentUser()!.username
                        self.bioLabel.text = (PFUser.currentUser()!.objectForKey("aboutMe") as? String)
                        
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
                        self.loadEntriesData()
                        self.usernameLabel.text = PFUser.currentUser()!.username
                        self.bioLabel.text = (PFUser.currentUser()!.objectForKey("aboutMe") as? String)
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
        
        if(PFUser.currentUser() != nil){
        
        // Load cell Data
            if(PFUser.currentUser() != nil){
                self.loadEntriesData()
                
                
                self.loadFavs()
            }
      
        
        
        
        self.usernameLabel.text = PFUser.currentUser()!.username
        self.bioLabel.text = (PFUser.currentUser()!.objectForKey("aboutMe") as? String)
            
            
        }else{
            
            signinUser()
            self.loadEntriesData()
            
        }
    }

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(ProfileCell.self, forCellReuseIdentifier: "groupcell")
        
        
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
        cell.usernameLabel.text = joke.objectForKey("senderName") as? String
        
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.dateLabel.text = dateFormatter.stringFromDate(joke.createdAt!)
        
        var likesArray = joke.objectForKey("likersArray") as! NSArray
        var dislikesArray = joke.objectForKey("dislikersArray") as! NSArray
        
        var net = likesArray.count - dislikesArray.count
        
        cell.counterLabel.text = String(net)
        
        var currentUser = PFUser.currentUser()
        
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
            
            
            if(currentUser!.objectForKey("isAdmin")! as! NSObject == true){
                
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
        
        var joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        
        var likersArray = joke.objectForKey("likersArray") as! NSArray
        
        var objectId:NSString = PFUser.currentUser()!.objectId!
        if(!(likersArray.containsObject(objectId))){
            
            joke.addObject(objectId, forKey: "likersArray")
            joke.removeObject(objectId, forKey: "dislikersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("_Rose saved")
                }else{
                    println("_Rose error")
                }
                
            })
            
        }else if((likersArray.containsObject(objectId))){
            
            joke.removeObject(objectId, forKey: "likersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("_Rose saved")
                }else{
                    println("_Rose error")
                }
                
            })
            
        }
        self.tableView.reloadData()
    }
    
    func tomatoBtnClicked(sender: UIButton!) {
        
        println("Tomato Btn Clicked")
        
        var joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        var dislikersArray = joke.objectForKey("dislikersArray") as! NSArray
        
        var objectId:NSString = PFUser.currentUser()!.objectId!
        
        if(!(dislikersArray.containsObject(objectId))){
            joke.addObject(objectId, forKey: "dislikersArray")
            joke.removeObject(objectId, forKey: "likersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("Tomato saved")
                }else{
                    println("Tomato error")
                }
                
            })
        }else if((dislikersArray.containsObject(objectId))){
            joke.removeObject(objectId, forKey: "dislikersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("_Tomato saved")
                }else{
                    println("_Tomato error")
                }
                
            })
        }
        self.tableView.reloadData()
    }
    
    func favBtnClicked(sender: UIButton!) {
        
        println("Favorite Btn Clicked")
        
        
        var joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        var jokeObjectId = joke.objectId
        
        var relation = PFUser.currentUser()!.relationForKey("favoriteJokes") as PFRelation
        
        // Check if the joke is already in favorited
        
        if(self.favArray.containsObject(jokeObjectId!)){
            relation.removeObject(joke)
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("_Joke un-favorited")
                }else{
                    println("_Un-favorite error")
                }
            })
            
        }else{
            relation.addObject(joke)
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("_Joke favorited")
                    
                }else{
                    println("_Favorite error")
                }
            })
        }
        
        self.tableView.reloadData()
    }
    
    
    //########################################################
    
    
    
    
    //************ Admin Functions **********
    func banBtnClicked(sender: UIButton!) {
        
        var confirmationAlert = UIAlertController(title: "Are you sure?", message: "User will be banned permanently", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            
            var joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
            
            var authorId = joke.objectForKey("senderId") as! String
            var author = PFUser()
            author.objectId = authorId
            
            author.deleteInBackgroundWithBlock { (bool:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    println("User banned!")
                }
            }
            
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
            println("User not banned")
            
        }))
        
        presentViewController(confirmationAlert, animated: true, completion: nil)
        
        
        self.tableView.reloadData()
    }
    
    
    func delBtnClicked(sender: UIButton!) {
        
        var confirmationAlert = UIAlertController(title: "Are you sure?", message: "Joke will be deleted permanently", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            
            var joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
            
            joke.deleteInBackgroundWithBlock { (bool:Bool, error:NSError?) -> Void in
                
                if(error == nil){
                    println("Joke deleted!")
                }
            }
            
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
            println("Joke not deleted")
            
        }))
        
        presentViewController(confirmationAlert, animated: true, completion: nil)
        
        
        self.tableView.reloadData()
    }
    
    
    func ftBtnClicked(sender: UIButton!) {
        
       
        var joke = self.timelineData.objectAtIndex(sender.tag) as! PFObject
        
        if(joke.objectForKey("isOnStage")! as! NSObject == false){
            
            sender.titleLabel?.text = "Un-Ft"
            joke.setValue(true, forKey: "isOnStage")
            
            var todaysDate:NSDate = NSDate()
            joke.setValue(todaysDate, forKey: "featuredAt")
            
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("Joke FEATURED!")
                    
                }else{
                    println("Error occured while featuring")
                }
            })
            
        }else{
            
            sender.titleLabel?.text = "Ft"
            joke.setValue(false, forKey: "isOnStage")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                if(error == nil){
                    println("Joke UN-FEATURED!")
                }else{
                    println("Error occured un-featuring")
                }
            })
            
            
        }
        self.tableView.reloadData()
    }

    
    //************
    
    
    
    
    
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
