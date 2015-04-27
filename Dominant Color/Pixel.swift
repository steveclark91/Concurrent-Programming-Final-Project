//
//  Pixel.swift
//  Dominant Color
//
//  Created by Stephen Clark on 4/10/15.
//  Copyright (c) 2015 Stephen Clark. All rights reserved.
//

import Foundation
import UIKit

class Pixel
{
    private var red: CGFloat
    private var green: CGFloat
    private var blue: CGFloat
    
    // Default Constructor. Set pixel to black.
    init()
    {
        self.red = 0
        self.green = 0
        self.blue = 0
    }
    
    // Constructor to create pixel based on input
    init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.red = r
        self.green = g
        self.blue = b
    }
    
    /// Returns the minimum color value
    func min() -> (min: CGFloat, color: Int)
    {
        var minVal = red
        var colorIndex = 0
        
        if green < minVal { minVal = green; colorIndex = 1 }
        if blue < minVal { minVal = blue; colorIndex = 2 }
        
        return (minVal, colorIndex)
    }
    
    /// Returns the maximum color value
    func max() -> (max: CGFloat, color: Int)
    {
        var maxVal = red
        var colorIndex = 0
        
        if green > maxVal { maxVal = green; colorIndex = 1 }
        if blue > maxVal { maxVal = blue; colorIndex = 2 }
        
        return (maxVal, colorIndex)
    }
    
    /// Returns the range of the color values
    func range() -> CGFloat
    {
        return (max().max - min().min)
    }
    
    /// Returns the RGB value of the pixel
    func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat)
    {
        return (red, green, blue)
    }
    
    /// Returns the dominant color of the pixel
    func color() -> Int
    {
        // If the range of the pixels is within 20 then the dominant
        // color is greyscale
        if (range() <= 20)
        {
            if (max().max < 55) { return 6 }
            else if (max().max < 128) { return 7 }
            else if (max().max < 200) { return 8 }
            else { return 9 }
        }
        
        // Else, the dominant color is either red, green, blue
        // yellow, magenta, or cyan
        if (red >= 200 && green <= 128 && blue <= 128) { return 0 }
        else if (red <= 128 && green >= 200 && blue <= 128) { return 1 }
        else if (red <= 128 && green <= 128 && blue >= 200) { return 2 }
        else if (red >= 165 && green >= 165 && blue <= 128) { return 3 }
        else if (red >= 165 && green <= 128 && blue >= 165) { return 4 }
        else if (red <= 128 && green >= 165 && blue >= 165) { return 5 }
        
        else { return max().color }
    }
    
}