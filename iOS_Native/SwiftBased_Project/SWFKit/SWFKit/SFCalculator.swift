//
//  SFCalculator.swift
//  SWFKit
//
//  Created by Ashish Nigam on 20/01/16.
//  Copyright © 2016 Ashish. All rights reserved.
//

import Foundation

public class SFCalculator {
    var internalVar : String = "SFCalculator Class";
    
    public init(newSFCalculator : String) {
        if(newSFCalculator.characters.count > 20){
            internalVar = newSFCalculator;
        }
    }
    
    public func printCurrentString(cString : String){
        print("Printing in SFCalculator class " + cString);
        print("Printing in SFCalculator class internalVar = " + internalVar);
    }
}