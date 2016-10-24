//
//  ViewController.swift
//  MemeMe1
//
//  Created by Cece Soudaly on 10/13/16.
//  Copyright © 2016 CeceMobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
  
    @IBOutlet weak var imagePicker: UIImageView!
    
    @IBOutlet weak var topText: UITextField!

    @IBOutlet weak var bottomText: UITextField!
    
    let picker = UIImagePickerController()
    
    let memeTextAttributes = [
        
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Didot", size: 30)!,
        NSStrokeWidthAttributeName: -3.0
        
    ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        topText.isHidden = true
        bottomText.isHidden = true
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.center
        bottomText.textAlignment = NSTextAlignment.center
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.delegate = self
        bottomText.delegate = self
        
        //topText.becomeFirstResponder()
    }

    @IBAction func pickAnImage(_ sender: AnyObject) {
        print("Hello Pick an image.");
    
         
        picker.delegate = self // delegate added
        // Only allow photos to be picked, not taken
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        
        //Text fields
        topText.isHidden = false
        bottomText.isHidden = false
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imagePicker.contentMode = .scaleAspectFit //3
        imagePicker.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
     // Subscribe
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    // Unsubscribe
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        _ = NotificationCenter.default
            
    }
//
//    func keyboardWillShow(notification: NSNotification) {
//        self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
//    }
//    
//    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
//        let userInfo = notification.userInfo!
//        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
//        return keyboardSize.cgRectValue.height
//    }
    
    /// This is for editing text
//    func textFieldDidBeginEditing(textField: UITextField) {
//        print("TextField did begin editing method called")
//    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        print("TextField did end editing method called")
//    }
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        print("TextField should begin editing method called")
//        return true;
//    }
//    func textFieldShouldClear(textField: UITextField) -> Bool {
//        print("TextField should clear method called")
//        return true;
//    }
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        print("TextField should snd editing method called")
//        return true;
//    }
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        print("While entering the characters this method gets called")
//        return true;
//    }
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        print("TextField should return method called")
//       // topText.resignFirstResponder();
//        return true;
//    }
//    
    

}

