//
//  MyProfileController.swift
//  ChatRoom
//
//  Created by Mutian on 4/18/17.
//  Copyright © 2017 Binwei Xu. All rights reserved.



import UIKit
import Firebase
class MyProfileController: UITableViewController {
    let numberOfRowsAtSection: [Int] = [11,5]
    fileprivate let itemDataSource: [[(name: String, iconImage: UIImage?)]] = [
        [
            ("", nil),
            ],
        [
            ("Album", UIImage(named:"Album"))
            ],
       
        [
            ("Settings", UIImage(named:"Settings")),
            ],
        ]
    
    /**
        When the view is loaded,changes the listTableView configuration so that it is presented correctly on the screen
     
        @param None
     
        @return None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "Me"
        
        self.tableView.register(AvatarTableViewCell.self, forCellReuseIdentifier: "AvatarTableViewCell")
//        self.tableView.register(UINib(nibName: "AvatarTableViewCell", bundle: nil), forCellReuseIdentifier: "AvatarTableViewCell")
//        self.tableView.register(UINib(nibName: "ImageTextTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTextTableViewCell")
        self.tableView.register(ImageTextTableViewCell.self, forCellReuseIdentifier: "ImageTextTableViewCell")
        print(itemDataSource.count)
        self.tableView.tableFooterView = UIView()

        // use is not logged in, show the login page
        checkIfUserIsLoggedIn()
        
        
    }
    
    /**
        Dispose of any resources that can be recreated.
     
        @param None
     
        @return None
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /**
        Checks if the user is logged in, if yes stay in this view. If not, logout the user by calling the handle logout
     
        @param None
     
        @return None
     */
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            //            fetchUserAndSetupNavBarTitle()
            print(itemDataSource.count)
        }
    }
    /**
        Logs out user's account and present the LoginViewController to the user
     
        @param None
     
        @return None
     */
    func handleLogout() {
        
        // when logout bottom is clicked, sign out the current account
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError{
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.myProfileViewController = self //allow nav bar title update
        
        self.present(loginController, animated:true, completion: nil)
    }
    /**
        Overrides the numberOfSections function to configure the number of sections
     
        @param tableView - the table view you want to change
     
        @return None
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemDataSource.count
    }


    /**
         Overrides the didSelectRowAt function to configure the action when user selects a row
         
         @param indexPath - an IndexPath object that suggests the row that the user selects
         
         @return None
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /**
         Overrides the didSelectRowAt function to configure the action when user selects a row
         
         @param indexPath - an IndexPath object that suggests the row that the user selects
         
         @return None
    */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        } else {
            return 20
        }
    }
    /**
         Override the heightForRowAt function to configure the the height for different rows
         
         @param indexPath - an IndexPath object that suggests the row that is to be configured
         
         @return height - an double that is the height for the given row
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88.0
        } else {
            return 44.0
        }
    }


    /**
        Overrides the heightForFooterInSection function to configure the the height for different footer sections
     
        @param section - an integer that suggests the section of the footer that is to be configured
     
        @return height - an double that is the height for the given section in the footer
     */
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    /**
        Overrides the numberOfRowsInSection function to configure the the number of rows for different sections
     
        @param section - an integer that suggests the section of the footer that is to be configured
     
        @return number - an integer that is the number of rows for the given section
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.itemDataSource[section]
        return rows.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserAndSetupNavBarTitle()
    }
    
    // fetch User object from NewMessageController and pass to chatlogcontroller
    var user: User?
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            // for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.user?.setValuesForKeys(dictionary)
                print(self.user?.email)
            }
        }, withCancel: nil)
    }
    
    /**
        Overrides the cellForRowAt function to configure the cell for different rows in the table view
     
        @param indexPath - an IndexPath object that suggests the row that is to be configured
     
        @return cell - a cell object that is configured to be inside of the given row
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell{
        if (indexPath.section == 0){
//            let cell:AvatarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AvatarTableViewCell", for: indexPath) as! AvatarTableViewCell
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AvatarTableViewCell")as! AvatarTableViewCell
//            
            let cell = Bundle.main.loadNibNamed("AvatarTableViewCell", owner: self, options: nil)?.first as! AvatarTableViewCell
            
//            if let profileImageUrl = self.user?.profileImageUrl {
//                cell.avatarImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
//            }
//            cell.nicknameLabel.text = user?.name
//            cell.chatIDLabel.text = user?.email
            return cell
        }
        else{
//            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ImageTextTableViewCell", for: indexPath)
            
            let cell = Bundle.main.loadNibNamed("ImageTextTableViewCell", owner: self, options: nil)?.first as! ImageTextTableViewCell

//            cell.iconImageView.image = itemDataSource[indexPath.section][indexPath.row].iconImage
            cell.titleLabel.text = itemDataSource[indexPath.section][indexPath.row].name
            return cell
        }
            
    }

}
    



