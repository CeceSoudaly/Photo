//
//  ViewController.swift
//  MemeMe1
//
//  Created by Cece Soudaly on 10/13/16.
//  Copyright © 2016 CeceMobile. All rights reserved.
//

import UIKit
import AVFoundation
import Social

class ViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
  
    @IBOutlet weak var imagePicker: UIImageView!
    
    @IBOutlet weak var topText: UITextField!

    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var takePictue: UIBarButtonItem!
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var ToolBar: UIToolbar!
//    var meme: meme?
    
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
        
        topText.becomeFirstResponder()
        bottomText.becomeFirstResponder()
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            takePictue.isEnabled = false;
            
        }

    }
    
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        
       if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagepicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagepicker.allowsEditing = false
            self.present(imagepicker, animated: true, completion: nil)
            
        }else
       {
       
            let alertController = UIAlertController(title: title, message: "camera not available",preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    @IBAction func pickAnImage(_ sender: AnyObject) {
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
    
    @IBAction func saveImage(_ sender: AnyObject) {

        //hide the tool bar
        ToolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame,
                                          afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(memedImage,nil, nil, nil)
        //resumed the tool bar
        ToolBar.isHidden = false
    }
    
    
    @IBAction func shareImage(shareImage:UIImage?) {
        print("sharing....pictue.");
     }
    
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingImage image:UIImage!,editingInfo:[NSObject:AnyObject]!)
    {
        imagePicker.image = image
        self.dismiss(animated: true, completion: nil)
    
    }
       // Subscribe
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topText.resignFirstResponder()
        bottomText.resignFirstResponder()
  
    }

     //Unsubscribe
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    /// This is for editing text
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
       if(textField == bottomText)
        {
            bottomText.text = ""
               moveTextField(textField: textField, moveDistance: -250, moveUp: true)
       }else{
            topText.text = ""
        }
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if(textField == bottomText)
        {
            moveTextField(textField: textField, moveDistance: -250, moveUp: false)
        }
      
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print("TextField should begin editing method called")
        
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       // print("TextField should snd editing method called")
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // print("While entering the characters this method gets called")
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // print("TextField should return method called")
        topText.resignFirstResponder();
        bottomText.resignFirstResponder();
        return true;
    }
    
 
    func moveTextField(textField:UITextField, moveDistance: Int,moveUp: Bool)
    {
        let moveDuration = 0.3
        let movement:CGFloat = CGFloat(moveUp ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }


   
}

