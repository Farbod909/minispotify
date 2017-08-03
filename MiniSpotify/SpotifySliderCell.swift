//
//  SpotifySliderCell.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 8/2/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Foundation
import Cocoa

class SpotifySliderCell: NSSliderCell {

    override func drawKnob(_ knobRect: NSRect) {
        let image = #imageLiteral(resourceName: "grayImage")
        image.isTemplate = true
        NSColor(patternImage: image).set()
        NSRectFill(knobRect)
    }

    override func knobRect(flipped: Bool) -> NSRect {
        let theSlider: NSSlider? = (controlView as? NSSlider)
        let myBounds: NSRect? = theSlider?.bounds
        let knobSize: NSSize =  NSSize(width: 4, height: 8)
        let travelLength: Float = Float((myBounds?.size.width)!) - Float(knobSize.width)
        let valueFrac: Double? = ((theSlider?.doubleValue)! - (theSlider?.minValue)!) / ((theSlider?.maxValue)! - (theSlider?.minValue)!)
        let knobLeft: Float = roundf(Float(valueFrac!) * travelLength)
        let knobMinY: Float? = roundf(Float((myBounds?.origin.y)!) + 0.5 * Float((myBounds?.size.height)! - knobSize.height))
        let knobRect: NSRect = NSMakeRect(CGFloat(knobLeft), CGFloat(knobMinY!), knobSize.width, knobSize.height)
        return knobRect
    }
}
