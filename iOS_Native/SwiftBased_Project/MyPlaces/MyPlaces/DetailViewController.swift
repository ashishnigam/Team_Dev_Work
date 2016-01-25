//
//  DetailViewController.swift
//  MyPlaces
//
//  Created by Ashish Nigam on 12/01/16.
//  Copyright © 2016 Ashish. All rights reserved.
//

import UIKit

import SWFKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var swfIns : SFMath = SFMath(newMessage: "ashish nigam init");
    var swfIns1 : SFMath = SFMath(newMessage: "ashish nigam init will print this as more than 20");
    var swfIns2 : SFCalculator = SFCalculator(newSFCalculator: "ashish nigam init will print this as more than 20");
    var swWave : SFSineWave = SFSineWave();

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        swfIns.printCurrentString("In view did load with framework");
        swfIns1.printCurrentString("\n In view did load with framework");
        swfIns2.printCurrentString("\n new calculator");
        swWave.printCurrentWave();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

