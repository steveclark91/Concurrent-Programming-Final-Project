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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
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
        
        println(imageView.image!.size)
        
        // Used to determine how long it took an image to be analyzed
        let startTime = NSDate()
        
        // Split the image into 8 strips
        let imageStrips = splitImage(8)
        
        // Stores the dominant color of each strip
        var colorList = [String](count: 8, repeatedValue: "")
        
        
        // Code used from a post on StackOverflow
        // http://stackoverflow.com/questions/29886827/use-dispatch-async-to-analyze-an-array-concurrently-in-swift/29887442?noredirect=1#comment47899968_29887442
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        
        let qos_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0)
        let syncQueue = dispatch_queue_create("syncQueue", qos_attr)
        
        
        for i in 0 ..< 8
        {
            dispatch_group_async(group, queue){
                let color = self.photoAnalyzer.analyzeColors(imageStrips[i])
                dispatch_sync(syncQueue){
                    colorList[i] = color
                    return
                }
            }
        }
        
        println(colorList)
        
        /* 
            Passes the current image to the photo analyzer
            Uncomment the following line to run analyzer sequentially
        */
        //let color = photoAnalyzer.analyzeColors(imageView.image!)
        
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
    
    // Splits the image into a certain number of strips.  Returns a list of images.
    private func splitImage(numStrips: Int) -> [UIImage]
    {
        // Get image data
        let myImage = imageView.image!
        let newWidth = myImage.size.width
        let newHeight = (myImage.size.height) / CGFloat(numStrips)
        
        // Stores the split strips of the image
        var splitImages = Array<UIImage>()
        
        for (var i = 0; i < numStrips; i++)
        {
            // Determines where to split the image next
            let stripVert = CGFloat(i) * newHeight
            
            // The size of the split image
            let cropRect = CGRectMake(0.0, stripVert, newWidth, newHeight)
            
            // Creates an image from the specified size and location
            let tempImage = CGImageCreateWithImageInRect(myImage.CGImage!, cropRect)
            
            // Converts created image to a UIImage
            let newImage = UIImage(CGImage: tempImage)!
            
            // Add image strip to array
            splitImages.append(newImage)
        }
        
        return splitImages
    }
}

