//
//  Analyzer.swift
//  Dominant Color
//
//  Created by Stephen Clark on 4/10/15.
//  Copyright (c) 2015 Stephen Clark. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        var r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        var g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        var b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        var a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class Analyzer
{
    /*
        Index for each color:
            0 - Red
            1 - Green
            2 - Blue
            3 - Yellow
            4 - Magenta
            5 - Cyan
            6 - Black
            7 - Dark Grey
            8 - Light Grey
            9 - White
    */
    private var colorCount = [Int](count: 10, repeatedValue: 0)
    
    /// Imports an image to be analyzed and returns a string containing the name of the dominant color
    func analyzeColors(myImage: UIImage) -> String
    {
        // Get image information
        let imgWidth = myImage.size.width
        let imgHeight = myImage.size.height
        let totalPixels = imgWidth * imgHeight
        
        // Local variables for photo analysis
        var pixelCount = CGFloat(0)
        var previousVal = CGFloat(0)
        var pixel = Pixel()
        var colorIndex: Int = 0
        
        // Scan and analyze the image pixel by pixel
        for (var i = CGFloat(0); i < imgWidth; i++)
        {
            for (var j = CGFloat(0); j < imgHeight; j++)
            {
                pixel = getPixelFromImage(myImage, x: i, y: j)
                colorIndex = pixel.color()
                colorCount[colorIndex]++
                pixelCount++
            }
            
            // Prints completion progress to the console.  Not relevant to analysis.
            let percent = floor(((pixelCount / totalPixels) * 100))
            if (percent > previousVal)
            {
                println("\(percent)%")
                previousVal++
            }
        }
        
        // Determine and return the string for the dominant color of the image
        var dominantIndex = indexOfDominantColor(colorCount)
        return getDominantColorName(dominantIndex)
    }
    
    // Returns the pixel you want analyzed
    private func getPixelFromImage(image: UIImage, x: CGFloat, y:CGFloat) -> Pixel
    {
        // CGFloats for storing RGBA values
        var redVal: CGFloat = 0
        var greenVal: CGFloat = 0
        var blueVal: CGFloat = 0
        var cgAlpha: CGFloat = 0
        
        // Use the getPixelColor method from the extension added to UIImage
        let pixelLocation = CGPointMake(x, y)
        var pixelRGB = image.getPixelColor(pixelLocation)
        pixelRGB.getRed(&redVal, green: &greenVal, blue: &blueVal, alpha: &cgAlpha)
        
        // Range is 0 - 1, update to 0 - 255
        redVal *= 255
        greenVal *= 255
        blueVal *= 255
        
        return Pixel(r: redVal, g: greenVal, b: blueVal)
    }
    
    
    /// Returns the index of the dominant color
    private func indexOfDominantColor(colorArray: [Int]) -> Int
    {
        var max = colorArray[0]
        var maxIndex = 0
        var loopBound = colorArray.count
        
        // Determine the max pixel count in the pixel array
        for (var i = 1; i < loopBound; i++)
        {
            if (colorArray[i] > max)
            {
                max = colorArray[i]
                maxIndex = i
            }
        }
        
        return maxIndex
    }
    
    /// Returns a string containing the name of the dominant color
    private func getDominantColorName(colorIndex: Int) -> String
    {
        switch colorIndex
        {
            case 0: return "Red"
            case 1: return "Green"
            case 2: return "Blue"
            case 3: return "Yellow"
            case 4: return "Magenta"
            case 5: return "Cyan"
            case 6: return "Black"
            case 7: return "Dark Grey"
            case 8: return "Light Grey"
            case 9: return "White"
            default: return ""
        }
    }
}