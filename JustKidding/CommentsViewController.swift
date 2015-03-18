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
    var jokeOfComment = PFObject(className: "Comments")
    
    // Load
    func loadData(){
        // Initially, remove what is already there
        commentsArray.removeAllObjects()
        
        var relation:PFRelation = self.jokeOfComment.relationForKey("associatedComments")
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

        var likesArray = comment.objectForKey("likersArray") as NSMutableArray
        
        cell.likesLabel.text = String(likesArray.count)
        
        
        return cell
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
