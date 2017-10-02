//
//  NewMessageController.swift
//  ChatRoom
//
//  Created by Binwei Xu on 3/22/17.
//  Copyright © 2017 Binwei Xu. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    //class variables
    let cellId = "cellId"
    var users = [User]() // array to store all other users visible to current user
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    
    }
    
    func fetchUser() {
        // We can change the directory here to fetch only the connected friends
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                
                user.id = snapshot.key
                
                // this setter may crash the app if the User class properties don't exactly match up with the Firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                // This will crash because of background thread, so let's use dispatch_async to fix
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                // safer choice instead of the setter above is to individually fetch and set the values
//                user.name = dictionary["name"]
            }
        }, withCancel: nil)
    }
    
    // return to MessageController
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    var messagesController: MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    
    // set the height of each cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}

