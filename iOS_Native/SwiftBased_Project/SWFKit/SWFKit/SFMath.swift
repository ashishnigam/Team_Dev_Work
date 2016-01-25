//
//  SFMath.swift
//  SWFKit
//
//  Created by Ashish Nigam on 20/01/16.
//  Copyright © 2016 Ashish. All rights reserved.
//

import Foundation

public class SFMath: NSObject {
    var internalVar : String = "SFMath Class";
    
    public init(newMessage : String) {
        if(newMessage.characters.count > 20){
            internalVar = newMessage;
        }
    }
    
    public func printCurrentString(cString : String){
        print("Printing in SFMath class " + cString);
        print("Printing in SFMath class internalVar = " + internalVar);
    }
}
