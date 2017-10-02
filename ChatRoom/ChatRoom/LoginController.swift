//
//  LoginController.swift
//  ChatRoom
//
//  Created by Binwei Xu on 3/17/17.
//  Copyright © 2017 Binwei Xu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate {
    var myProfileViewController: MyProfileController?
    var messagesController: MessageController? //allow nav bar title update
    
    // restrict to only portrait version on iphone devices
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    // forbid rotation
    override var shouldAutorotate: Bool {
        return false
    }
    
    // instantiate a inputs container view
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    // instantiate a button for login or register
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 236, g: 22, b: 22)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // add action for button
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    // all the following Google login components are still under construction
    
    let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = GIDSignInButtonStyle.standard
        button.colorScheme = GIDSignInButtonColorScheme.light
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showGoogleLogin)))
        return button
    }()
    
    let customGoogleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Google Sign in", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }()
    
    func setupCustomGoogleLoginButton(){
        customGoogleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customGoogleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 12).isActive = true
        customGoogleLoginButton.widthAnchor.constraint(equalTo: googleLoginButton.widthAnchor).isActive = true
        customGoogleLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func handleGoogleLogin(){
        GIDSignIn.sharedInstance().signIn()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupGoogleLoginButton() {
        // Need x, y, width and height constraints
        googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleLoginButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        googleLoginButton.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        googleLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    // handle the switch between login and register and call helper method respectively
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }

    // helper method that handle login action when button is hit
    func handleLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        // log in through Firebase
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error as Any)
                return
            }
            self.messagesController?.fetchUserAndSetupNavBarTitle() //update nav bar title
            
            //successfully log in and proceed to MessagesController
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    // instantiate components in the input container : name textbox
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name: Steph Curry"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    // instantiate components in the input container : separator
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // instantiate components in the input container : email textbox
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address: stcurry@davidson.edu"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    // instantiate components in the input container : separator
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // instantiate components in the input container : password textbox
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    // "let" is substituted by "lazy var" for access to using "self" in addGestureRecognizer
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addProfile.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        //this should be added to the image where user should click to add profile image
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        imageView.isUserInteractionEnabled = true
        //when log in, stay transparent
        imageView.alpha = 0.0
        return imageView
    }()
    
    // logo of AcquainTest header
    lazy var logoHeaderView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "loginpageprofile.png")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFill
        
        return logoView
    }()
    
    // switch between login and register
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    // helper function that handle the changes in login page view between login and register.
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: .normal)
        
        // make profile placeholder appear
        //profileImageView.isHidden = self.loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 1, delay: 0.5, animations: {
                self.profileImageView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.8, delay: 0.0, animations: {
                self.profileImageView.alpha = 0.0
            })
        }
        
        // change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100:150
        
        //change height of text fields inside inputContainerView
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2:1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2:1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 1, animations: {
                let trans = CGAffineTransform(translationX: 0, y: -85)
                let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.logoHeaderView.transform = trans.concatenating(scale)
            })
        } else {
            UIView.animate(withDuration: 0.8, delay: 0.3, animations: {
                let trans = CGAffineTransform(translationX: 0, y: 0)
                let scale = CGAffineTransform.identity
                self.logoHeaderView.transform = trans.concatenating(scale)
            })
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackground()
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(logoHeaderView)
        view.addSubview(googleLoginButton)
        
//        view.addSubview(customGoogleLoginButton)
//        setupCustomGoogleLoginButton()
        
        setupGoogleLoginButton()
        setupInputsContainterView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupLogoHeaderView()
        
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
    }
    
    func assignBackground(){
        let background = UIImage(named: "loginpagebackground")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }

    
    func setupLoginRegisterSegmentedControl() {
        // Need x, y, width and height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        //loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    // keep a reference to the attributes of this class
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var logoHeaderViewTopAnchor: NSLayoutConstraint?
    
    func setupLogoHeaderView() {
        // Need x, y, width and height constraints
        logoHeaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let logoHeaderViewTopHeader = logoHeaderView.topAnchor.constraint(equalTo: view.topAnchor)
        logoHeaderViewTopHeader.isActive = true
        logoHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logoHeaderView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    func setupInputsContainterView() {
        // Need x, y, width and height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 12).isActive = true
        //inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // Need x, y, width and height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = true
        
        // Need x, y, width and height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Need x, y, width and height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Need x, y, width and height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Need x, y, width and height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        // Need x, y, width and height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupProfileImageView() {
        // Need x, y, width and height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        //set the profile to a circle
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// helper which allows easier setup of UIColor
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
