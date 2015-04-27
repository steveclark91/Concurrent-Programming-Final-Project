//
//  ViewController.swift
//  Dominant Color
//
//  Created by Stephen Clark on 4/10/15.
//  Copyright (c) 2015 Stephen Clark. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // Class variables to determine dominant color of image
    var photoAnalyzer = Analyzer()
    var color = String()
    
    
    // Outlets to UI
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var analyzeButton: UIBarButtonItem!
    
    
    // Grabs a photo from the camera or photo library
    @IBAction func addPhoto(sender: UIBarButtonItem)
    {
        let photoOption = UIAlertController(title: nil, message: "Select an Input Type", preferredStyle: .ActionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) -> Void in
            println("Photo Library Selected")
            self.chooseFromPhotoLibrary()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (alert: UIAlertAction!) -> Void in
            println("Camera Selected")
            self.chooseFromCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        photoOption.addAction(photoLibraryAction)
        photoOption.addAction(cameraAction)
        photoOption.addAction(cancelAction)
        
        self.presentViewController(photoOption, animated: true, completion: nil)
    }
    
    
    // Accesses the phones photo library for photo selection
    func chooseFromPhotoLibrary()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // Accesses the phones camera for photo selection
    func chooseFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject])
    {
        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // Display image to user
        imageView.image = newImage
        
        dismissViewControllerAnimated(true, completion: nil)
        
        // Now that a photo exists, enable the Analyze button
        analyzeButton.enabled = true
    }
    
    
    // Passes an image to the Analyzer class
    @IBAction func analyzePhoto(sender: UIBarButtonItem)
    {
        // Used to determine how long it took an image to be analyzed
        let startTime = NSDate()
        
        // INCOMPLETE
        // Used to split image into multiple strips. Will be moved to
        // seperate function once code is fully functional.
        let myImage = imageView.image!
        let newWidth = (myImage.size.width) / 2
        let newHeight = myImage.size.height
        var cropRect = CGRectMake(0.0, 0.0, newWidth, newHeight)
        
        var tempImage = CGImageCreateWithImageInRect(myImage.CGImage!, cropRect)
        
        let newImage = UIImage(CGImage: tempImage)!
        
        println("Original Image: \(myImage.size)")
        println("New Image: \(newImage.size)")

        imageView.image = newImage
        
        // Passes the current image to the photo analyzer
        let color = photoAnalyzer.analyzeColors(imageView.image!)
        
        // Used to determine how long it took an image to be analyzed
        let endTime = NSDate()
        let totalTime = endTime.timeIntervalSinceDate(startTime)
        
        // Print time to console
        println("Analysis took \(totalTime) seconds.")
        
        // Tell the user which color is dominant
        alertUser(color)
    }
    
    // Alerts the user when a photo has been analyzed and what the dominant color is
    private func alertUser(color: String)
    {
        let colorAlert = UIAlertController(title: "Dominant Color", message: color, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        
        colorAlert.addAction(dismissAction)
        
        self.presentViewController(colorAlert, animated: true, completion: nil)
    }
    
}

