//
//  ProfileCell.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/19/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet var jokeLabel: UILabel! = UILabel()
    @IBOutlet var favBtn: UIButton! = UIButton()
    @IBOutlet var tomatoBtn: UIButton! = UIButton()
    @IBOutlet var roseBtn: UIButton! = UIButton()
    @IBOutlet var dateLabel: UILabel! = UILabel()
    @IBOutlet var counterLabel: UILabel! = UILabel()
    @IBOutlet var usernameLabel: UILabel! = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
