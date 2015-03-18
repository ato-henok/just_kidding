//
//  CommentCell.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/17/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit



class CommentCell: UITableViewCell {

   
    @IBOutlet var dateLabel: UILabel! = UILabel()
    @IBOutlet var usernameLabel: UILabel! = UILabel()
    @IBOutlet var commentLabel: UILabel! = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}