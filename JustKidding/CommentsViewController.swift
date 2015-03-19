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
        var query:PFQuery = relation.query()
        query.orderByDescending("likersArray")

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("\(objects.count) comments.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.commentsArray.addObject(object)
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
        var addCommentAlert:UIAlertController = UIAlertController(title: "Comment", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        addCommentAlert.addTextFieldWithConfigurationHandler({
            textField in
            
            textField.placeholder = "Say something nice...jk"
        })
        
        addCommentAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { alertAction in
            
            let textFields:NSArray = addCommentAlert.textFields! as NSArray
            
            let commentTextField:UITextField = textFields.objectAtIndex(0) as UITextField
            
            var newComment:PFObject = PFObject(className: "Comments")
            newComment["comment"] = commentTextField.text
            newComment["commenterId"] = PFUser.currentUser().objectId
            newComment["commenterName"] = 	PFUser.currentUser().username
            newComment["likersArray"] = []
            newComment["redFlags"] = 0
            newComment.saveInBackgroundWithBlock({ (sucess:Bool, error:NSError!) -> Void in
                
                if(error == nil){
                    
                    var relation = self.commentEntry.relationForKey("associatedComments") as PFRelation
                    relation.addObject(newComment)
                    self.commentEntry.saveInBackgroundWithBlock({ (sucess:Bool, error:NSError!) -> Void in
                        
                        if(error == nil){
                              self.tableView.reloadData()
                              println("New comment related and saved")
                            
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CommentCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CommentCell
        
        let comment:PFObject = self.commentsArray.objectAtIndex(indexPath.row) as PFObject
        
        cell.commentLabel.text = comment.objectForKey("comment") as NSString
      
        cell.usernameLabel.text = comment.objectForKey("commenterName") as NSString
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        cell.dateLabel.text = dateFormatter.stringFromDate(comment.createdAt) as NSString

        var likesArray = comment.objectForKey("likersArray") as NSArray
        
        cell.likesLabel.text = String(likesArray.count)
        
        let like_selected = UIImage(named: "like_selected.png") as UIImage!
        let like_empty = UIImage(named: "like_empty.png") as UIImage!
        
        var likersArray = comment.objectForKey("likersArray") as NSArray
        
        if(likersArray.containsObject(PFUser.currentUser().objectId)){
            cell.likeBtn.setBackgroundImage(like_selected, forState: .Normal)
        }else{
            cell.likeBtn.setBackgroundImage(like_empty, forState: .Normal)
        }
        
        // Like button clicked
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: "likeBtnClicked:", forControlEvents: .TouchUpInside)
        
        return cell
    }

    func likeBtnClicked(sender:UIButton!){
        
        println("Like Btn Clicked")
        
        var comment = self.commentsArray.objectAtIndex(sender.tag) as PFObject
        var likersArray = comment.objectForKey("likersArray") as NSArray
        
        if(likersArray.containsObject(PFUser.currentUser().objectId)){
            comment.removeObject(PFUser.currentUser().objectId, forKey: "likersArray")
        }else{
            comment.addObject(PFUser.currentUser().objectId, forKey: "likersArray")
        }
        
        comment.saveInBackgroundWithBlock({ (bool:Bool, error:NSError!) -> Void in
            if(error == nil){
                println("_Like saved")
            }else{
                println("_Like error")
            }
            
        })
        self.tableView.reloadData()
        
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
