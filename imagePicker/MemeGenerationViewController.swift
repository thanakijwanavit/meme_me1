//
//  ViewController.swift
//  imagePicker
//
//  Created by nic Wanavit on 7/17/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import UIKit

class MemeGenerationViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var toolbarOutlet: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageToDisplay: UIImageView!
    @IBOutlet weak var cameraStatus: UILabel!
    /// Text Fields
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    
    // init deligate variables
    let topTextDelegate = TextFieldDelegate()
    let bottomTextDelegate = TextFieldDelegate()
    
    
    // create meme variable
    var meme: Meme?
    // keyboard status
    var keyboardStatus: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set up text field delegate
        setTextFieldAttributes()
        
        // set up camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if cameraButton.isEnabled == false {
            cameraStatus.text = "Camera Unavailable"
        }
        
        //// hide keyboard when touch something else
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        subscribeToKeyboardNotification()
        // check and activate buttons
        checkImageHideButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }
    
    @IBAction func pickImageWithCam(_ sender: Any) {
        openImagePicker(.camera)
    }

    @IBAction func pickImage(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    ////save Memes
    
    @IBAction func saveMemeButton(_ sender: Any) {
        saveMeme()
    }
    
    /// share button
    
    @IBAction func shareButton(_ sender: Any) {
        // image to share
        // let image = self.Meme
        // set up activity view controller
//        save()
        let imageToShare = [self.meme?.memedImage] as [UIImage?]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [UIImage?] as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed){
                self.saveMeme()
            }
            //Dismiss the Shareactivitycontroller
            self.dismiss(animated: true, completion: nil)
        }
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        imageToDisplay.image = nil
        checkImageHideButton()
    }
    /// finish or cancel image pick
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageToDisplay.image = image
            saveButton.isEnabled = true
            shareButton.isEnabled = true
            cancelButtonOutlet.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    /// Text Field section //////
    
    
/////// keyboard section ///////////////
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification(){
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if (self.bottomText.isEditing){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if (self.bottomText.isEditing){
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    /// hide keyboard
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    /// Creating memes ////////////
    func saveMeme() {
        // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageToDisplay.image!, memedImage: memedImage!)
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, nil , nil, nil)
        self.meme = meme
        
    }
    
    
    func generateMemedImage() -> UIImage? {
        
        hideToolbars(true)
        // TODO: Hide toolbar and navbar
        
        
       let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(imageToDisplay.frame.size, false, scale)
        view.drawHierarchy(in: CGRect(x: -imageToDisplay.frame.minX,y: -imageToDisplay.frame.minY,width: view.bounds.size.width,height: view.bounds.size.height), afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        print("view frame is :",view.frame)
        print("view frame size is:",view.frame.size)
        print("image frame is: ",imageToDisplay.frame)
        print("image frame size is:", imageToDisplay.frame.size)
        print("image bound is: ",imageToDisplay.bounds)
        print("image bound size is:", imageToDisplay.bounds,imageToDisplay.frame.minX,imageToDisplay.frame.minY)
        print("scale is:",scale)
        
        // TODO: Show toolbar and navbar
        hideToolbars(false)
        return memedImage
    }
    func hideToolbars(_ hide:Bool){
        toolbarOutlet.isHidden = hide
        cameraStatus.isHidden = hide
        navigationBar.isHidden = hide
    }
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }

    ///// check and disable the button if image is empty
    func checkImageHideButton(){
        if imageToDisplay.image == nil{
            shareButton.isEnabled = false
            saveButton.isEnabled = false
            cancelButtonOutlet.isEnabled = false
        }
    }
    func setTextFieldAttributes(){
        self.topText.delegate =  self.topTextDelegate
        self.topTextDelegate.label = "TOP"
        self.bottomText.delegate = self.bottomTextDelegate
        self.bottomTextDelegate.label = "BOTTOM"
    }
    // open an image picker
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }


}

