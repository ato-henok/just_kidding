//
//  TimelineTableViewController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/15/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse

class CrowdiewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timelineData:NSMutableArray = NSMutableArray()
    //var jokeObj:PFObject = PFObject()
    var jokeObj = PFObject(className: "Jokes")
    
    @IBOutlet var tableView: UITableView!
    
    // Load
    
    func loadData(){
        // Initially, remove what is already there
        timelineData.removeAllObjects()
        
        var stageQuery = PFQuery(className: "Jokes")
        stageQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects.count) jokes on crowd.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.timelineData.addObject(object)
                    }
                }
                
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Call the data loader
        self.loadData()
        
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
        
        self.tableView.registerClass(CrowdCell.self, forCellReuseIdentifier: "groupcell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let cell:CrowdCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CrowdCell
        
        let joke:PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject
        
        cell.jokeLabel.text = joke.objectForKey("joke") as NSString
        cell.usernameLabel.text = joke.objectForKey("senderName") as NSString
        
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.dateLabel.text = dateFormatter.stringFromDate(joke.createdAt)
        
        /*
        var likesArray = joke.objectForKey("likersArray")
        var dislikesArray = joke.objectForKey("dislikersArray")
        var net = likesArray.count - dislikesArray.count
        
        cell.likesCountLabel.text = String(net)
        
        */
        
        
        return cell
    }
    
    /*
    -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showUserProfile"]){
    
    NSString *userName = self.userName;
    UserProfileViewController *controller = [segue destinationViewController];
    controller.senderLabel = userName;
    }else if([segue.identifier isEqualToString:@"showComments"]){
    CommentsViewController *controller = [segue destinationViewController];
    controller.jokeForComment = self.jokeObj;
    }
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier? == "showComments" {
            
            let controller = segue.destinationViewController as CommentsViewController
            controller.jokeOfComment = self.jokeObj
            
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.jokeObj = self.timelineData.objectAtIndex(indexPath.row) as PFObject
        
        self.performSegueWithIdentifier("showComments", sender: self)
        
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
