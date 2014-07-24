//
//  LBImageProcessingViewController.swift
//  BangDevLab
//
//  Created by Bang Nguyen on 17/07/2014.
//  Copyright (c) Năm 2014 Bang Nguyen. All rights reserved.
//

import UIKit

class LBImageProcessingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    var picker : UIImagePickerController?
    var originImage : UIImage?
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @IBAction func filterA(sender: AnyObject) {
//        
//        if originImage {
//            
//            var imageSource = GPUImagePicture(image: originImage)
//            var imageFilter = GPUImageSepiaFilter()
//            
//            imageSource.addTarget(imageFilter)
//            imageFilter.useNextFrameForImageCapture()
//            imageSource.processImage()
//            
//            imageView.image = imageFilter.imageFromCurrentFramebuffer()
//        }
//    }
//    
//    @IBAction func filterB(sender: AnyObject) {
//        
//        if originImage {
//            
//            var imageFilter = GPUImagePixellateFilter()
//            imageView.image = imageFilter.imageByFilteringImage(originImage)
//        }
//    }
//    
//    @IBAction func filterC(sender: AnyObject) {
//        
//        if originImage {
//            
//            var imageFilter = GPUImageSketchFilter()
//            imageView.image = imageFilter.imageByFilteringImage(originImage)
//        }
//    }
//    
//    @IBAction func filterD(sender: AnyObject) {
//        
//        if originImage {
//            
//            var imageFilter = GPUImageThresholdSketchFilter()
//            imageView.image = imageFilter.imageByFilteringImage(originImage)
//        }
//    }
    
    @IBAction func selectPhoto(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Select Source", message: "Please select where to pick image", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                self.picker = UIImagePickerController()
                self.picker!.sourceType = UIImagePickerControllerSourceType.Camera
                self.picker!.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                self.picker!.delegate = self
                self.presentViewController(self.picker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Library", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                
                self.picker = UIImagePickerController()
                self.picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.picker!.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                self.picker!.allowsEditing = false
                self.picker!.delegate = self
                self.presentViewController(self.picker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: { (alert: UIAlertAction!) in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        imageView.image = image
        originImage = image
        picker.dismissViewControllerAnimated(false, completion: nil)
    }
    
    /*
    func processImg(origin: UIImage) {
        var image = origin.CGImage
        var raw = CGDataProviderCopyData(CGImageGetDataProvider(image))
        
        var context = getRGBABitmapContext(image)
        if !context {
            // error creating context
            return
        }
        
        // Get image width, height. We'll use the entire image.
        var w = CGImageGetWidth(image)
        var h = CGImageGetHeight(image)
        var rect = CGRectMake(0, 0, CGFloat(w), CGFloat(h))
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(context, rect, image);
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        var data = CGBitmapContextGetData (context);
        if data {
            
            // **** You have a pointer to the image data ****
            
            // **** Do stuff with the data here ****
            NSLog("hehe done")
        }
        
        // When finished, release the context
        CGContextRelease(context);
        // Free image data memory for the context
        if (data)
        {
            free(data);
        }

    }
    
    func getRGBABitmapContext(image: CGImageRef) -> CGContextRef? {
        
        var context : CGContextRef?
        var colorSpace : CGColorSpaceRef?
        var bitmapData : UnsafePointer<()>?
        var bitmapByteCount : Int?
        var bitmapBytesPerRow : Int?
        
        var pixelsWidth : UInt = CGImageGetWidth(image)
        var pixelsHeight : UInt = CGImageGetHeight(image)
        
        bitmapBytesPerRow   = Int(pixelsWidth * 4);
        bitmapByteCount     = Int(bitmapBytesPerRow! * Int(pixelsHeight))
        
        // Use the generic RGB color space.
        colorSpace = CGColorSpaceCreateDeviceRGB()
        if !colorSpace {
            NSLog("Error allocating color space\n")
            return nil
        }
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        bitmapData = malloc( UInt(bitmapByteCount!) )
        if !bitmapData {
            NSLog("Memory not allocated!")
            CGColorSpaceRelease( colorSpace )
            return nil
        }
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        context = CGBitmapContextCreate(bitmapData!, pixelsWidth as UInt, pixelsHeight as UInt, 8, bitmapBytesPerRow, colorSpace, CGBitmapInfo.AlphaInfoMask)
        if context {
            free(bitmapData!)
            NSLog("Context not created!")
        }
        
        // Make sure and release colorspace before returning
        CGColorSpaceRelease( colorSpace );
        
        return context;
    } */
}
