//
//  TabBarController.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 7/4/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = UIColor.purpleColor()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
        
        
    }

}
