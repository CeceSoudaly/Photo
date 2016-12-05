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
    
    var imageSaved = false
    
    let picker = UIImagePickerController()

    var memedImage: UIImage! = nil
    var memes: [Meme]!
    
    
    @IBOutlet weak var ToolBar: UIToolbar!
    
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
    
    //camera option
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
        
        //pick a new photo
        if(imageSaved == true)
        {
            imageSaved = false
        }
       
    }
    
    @IBAction func saveImage(_ sender: AnyObject) {
        
        if(imageSaved == false)
        {
            self.memedImage = generateMemedImage()
            saveMeme()
        }else
        {
            
            let alertController = UIAlertController(title: title, message: "The photo has already been saved.",preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func shareImage(_ sender: Any) {
    
        // memed image to activity view
        self.memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [self.memedImage!],
                                                  applicationActivities: nil)
        
        // Save image to shared
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                
                if(self.imageSaved == false)
                {
                    self.saveMeme()
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(activityVC, animated: true, completion: nil)
     }
    
    //Struct object to store an image
    struct Meme {
        
        var topTextField: String?
        var bottomTextField: String?
        var originalImage: UIImage?
        let memedImage: UIImage!
    }
    
    
    func saveMeme() {
         _ = Meme(topTextField: topText.text!, bottomTextField: bottomText.text!, originalImage: imagePicker.image!, memedImage:  self.memedImage)
        UIImageWriteToSavedPhotosAlbum( self.memedImage ,nil, nil, nil)
        imageSaved = true
    }
    
    func generateMemedImage() -> UIImage {
        
        //hide the tool bar
        ToolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //resumed the tool bar
        ToolBar.isHidden = false
        
        return memedImage
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

