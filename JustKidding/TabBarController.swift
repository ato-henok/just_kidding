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
        
        
        
        UITabBar.appearance().barTintColor = UIColor(red:155.0/255.0, green:89.0/255.0,blue:182.0/255.0,alpha:1.0)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:217.0/255.0, green:217.0/255.0,blue:217.0/255.0,alpha:1.0)], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
        
        
        
        
    }

}
