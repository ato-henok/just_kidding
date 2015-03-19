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
        var relation = PFUser.currentUser().relationForKey("favoriteJokes") as PFRelation
        var query = relation.query()
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects.count) favorite jokes on profile")
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
    
    func loadEntriesData(){
        // Initially, remove what is already there
        self.timelineData.removeAllObjects()
        var relation = PFUser.currentUser().relationForKey("userJokes") as PFRelation
        var query = relation.query()
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects.count) entries on profile")
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
    
    
    
    
    func loadFavs(){
        self.favArray.removeAllObjects()
        
        var relation = PFUser.currentUser().relationForKey("favoriteJokes") as PFRelation
        
        var query:PFQuery = relation.query()
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects.count) user favorites.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.favArray.addObject(object.objectId)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
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
        }else{
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
          
        
        // Load cell Data
        
        self.loadEntriesData()
        if(PFUser.currentUser() != nil){
            self.loadFavs()
        }
        
        
        self.usernameLabel.text = PFUser.currentUser().username
        self.bioLabel.text = PFUser.currentUser().objectForKey("aboutMe") as NSString
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
        let cell:ProfileCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ProfileCell
        
        let joke:PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject
        
        cell.jokeLabel.text = joke.objectForKey("joke") as NSString
        cell.usernameLabel.text = joke.objectForKey("senderName") as NSString
        
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.dateLabel.text = dateFormatter.stringFromDate(joke.createdAt)
        
        var likesArray = joke.objectForKey("likersArray") as NSArray
        var dislikesArray = joke.objectForKey("dislikersArray") as NSArray
        
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
        
        if(likesArray.containsObject(currentUser.objectId)){
            
            cell.roseBtn.setBackgroundImage(rose_selected, forState: UIControlState.Normal)
            cell.tomatoBtn.setBackgroundImage(tomato_empty, forState: .Normal)
        }else if(dislikesArray.containsObject(currentUser.objectId)){
            cell.tomatoBtn.setBackgroundImage(tomato_selected, forState: .Normal)
            cell.roseBtn.setBackgroundImage(rose_empty, forState: .Normal)
        }else{
            cell.roseBtn.setBackgroundImage(rose_empty, forState: .Normal)
            cell.tomatoBtn.setBackgroundImage(tomato_empty, forState: .Normal)
        }
        
        // Update favorite icon
        
        if(self.favArray.containsObject(joke.objectId)){
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
        
        var joke = self.timelineData.objectAtIndex(sender.tag) as PFObject
        
        var likersArray = joke.objectForKey("likersArray") as NSArray
        
        var objectId:NSString = PFUser.currentUser().objectId
        if(!(likersArray.containsObject(objectId))){
            
            joke.addObject(objectId, forKey: "likersArray")
            joke.removeObject(objectId, forKey: "dislikersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError!) -> Void in
                if(error == nil){
                    println("_Rose saved")
                }else{
                    println("_Rose error")
                }
                
            })
            
        }else if((likersArray.containsObject(objectId))){
            
            joke.removeObject(objectId, forKey: "likersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError!) -> Void in
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
        
        var joke = self.timelineData.objectAtIndex(sender.tag) as PFObject
        var dislikersArray = joke.objectForKey("dislikersArray") as NSArray
        
        var objectId:NSString = PFUser.currentUser().objectId
        
        if(!(dislikersArray.containsObject(objectId))){
            joke.addObject(objectId, forKey: "dislikersArray")
            joke.removeObject(objectId, forKey: "likersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError!) -> Void in
                if(error == nil){
                    println("Tomato saved")
                }else{
                    println("Tomato error")
                }
                
            })
        }else if((dislikersArray.containsObject(objectId))){
            joke.removeObject(objectId, forKey: "dislikersArray")
            joke.saveInBackgroundWithBlock({ (bool:Bool, error:NSError!) -> Void in
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
        
        
        var joke = self.timelineData.objectAtIndex(sender.tag) as PFObject
        var jokeObjectId = joke.objectId
        
        var relation = PFUser.currentUser().relationForKey("favoriteJokes") as PFRelation
        
        // Check if the joke is already in favorited
        
        if(self.favArray.containsObject(jokeObjectId)){
            relation.removeObject(joke)
            PFUser.currentUser().saveInBackgroundWithBlock({ (bool:Bool, error:NSError!) -> Void in
                if(error == nil){
                    println("_Joke un-favorited")
                }else{
                    println("_Un-favorite error")
                }
            })
            
        }else{
            relation.addObject(joke)
            PFUser.currentUser().saveInBackgroundWithBlock({ (bool:Bool, error:NSError!) -> Void in
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier? == "showComments" {
            
            let controller = segue.destinationViewController as CommentsViewController
            controller.commentEntry = self.jokeObj
            
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.jokeObj = self.timelineData.objectAtIndex(indexPath.row) as PFObject
        
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