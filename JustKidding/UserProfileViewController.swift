//
//  TimelineTableViewController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/22/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit
import Parse

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /*
    override func prefersStatusBarHidden() -> Bool {
    return true
    }
    */
    
    
    
    var timelineData:NSMutableArray = NSMutableArray()
    var favArray:NSMutableArray = NSMutableArray()
    
    //var jokeObj:PFObject = PFObject()
    var jokeObj = PFObject(className: "Jokes")
    var senderName = NSString()
    
    @IBOutlet var senderNameLabel: UILabel! = UILabel()
    @IBOutlet var tableView: UITableView!
    
    // Load
    
    func loadData(){
        // Initially, remove what is already there
        self.timelineData.removeAllObjects()
        
        var query = PFQuery(className: "Jokes")
        query.whereKey("senderName", equalTo: self.senderName)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects!.count) jokes from user \(self.senderName).")
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
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Load cell Data
        
        self.loadData()
        if(PFUser.currentUser() != nil){
            self.loadFavs()
        }
        self.senderNameLabel.text = self.senderName as String
            
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UserProfileCell.self, forCellReuseIdentifier: "groupcell")
        
        
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
        let cell:UserProfileCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UserProfileCell
        
        let joke:PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.jokeLabel.text = (joke.objectForKey("joke") as! String)
        
    
        
        cell.usernameLabel.text = (joke.objectForKey("senderName") as! String)
        
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.dateLabel.text = dateFormatter.stringFromDate(joke.createdAt!)
        
        
        var likesArray = joke.objectForKey("likersArray") as! NSArray
        var dislikesArray = joke.objectForKey("dislikersArray") as! NSArray
        
        var net = likesArray.count - dislikesArray.count
        cell.likesCountLabel.text = String(net)
        
        
        
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
        
        
        
        
        
        return cell
    }
    
    //########################################################
    //functions for Like, Dislke, and Favorite buttons
    
    func roseBtnClicked(sender: UIButton!) {
        
        println("Rose Btn Clicked")
        
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
    
    
    
    //########################################################
    //Preparation and sending of data to CommentsViewController
    
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
    
    //########################################################
    
    
    
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
