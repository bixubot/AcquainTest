//
//  customTabController.swift
//  ChatRoom
//
//  Created by Mutian on 4/10/17.
//  Copyright © 2017 Binwei Xu. All rights reserved.
//

import UIKit
class CustomTabBarController:UITabBarController{
    /**
        When the view is loaded,changed the listTableView configuration so that it is presented correctly on the screen
     
        @param None
     
        @return None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let messageController = MessageController()
        let recentMessagesNavController = UINavigationController(rootViewController: messageController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "Recent")
        let profileController = MyProfileController()
        let profileNavController = UINavigationController(rootViewController: profileController)
        
        profileNavController.tabBarItem.title = "Me"
        profileNavController.tabBarItem.image = UIImage(named:"Settings")
        
        
        viewControllers = [recentMessagesNavController,createNavControllerWithTitle(title: "Friends", imgName: "Friends"),createNavControllerWithTitle(title: "Leaderboard", imgName: "Leaderboard"),profileNavController]
    }
    
    /**
        A helper function to create a new tab item on the tab bar
     
        @param None
     
        @return None
     */
    private func createNavControllerWithTitle(title:String, imgName: String) ->UINavigationController{
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named:imgName)
        return navController
    }
}
