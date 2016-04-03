//
//  ViewController.swift
//  MaterialTest
//
//  Created by AirMyac on 3/28/16.
//  Copyright © 2016 AirMyac. All rights reserved.
//

import UIKit
import Material

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: TextField!
    @IBOutlet weak var testbtn: RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.placeholder = "First Name"
        textField.placeholderTextColor = MaterialColor.grey.base
        textField.font = RobotoFont.regularWithSize(20)
        textField.textColor = MaterialColor.black
        
        textField.titleLabel = UILabel()
        textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textField.titleLabelColor = MaterialColor.grey.base
        textField.titleLabelActiveColor = MaterialColor.blue.accent3
        
        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.AlwaysTemplate)
        
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.pulseScale = false
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
        textField.clearButton = clearButton
        
//        let imageCardView: ImageCardView = ImageCardView()
//        
//        // Image.
//        let size: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.width - CGFloat(40), 150)
//        imageCardView.image = UIImage.imageWithColor(MaterialColor.cyan.darken1, size: size)
//        
//        // Title label.
//        let titleLabel: UILabel = UILabel()
//        titleLabel.text = "Welcome Back!"
//        titleLabel.textColor = MaterialColor.white
//        titleLabel.font = RobotoFont.mediumWithSize(24)
//        imageCardView.titleLabel = titleLabel
//        imageCardView.titleLabelInset.top = 100
//        
//        // Detail label.
//        let detailLabel: UILabel = UILabel()
//        detailLabel.text = "It’s been a while, have you read any new books lately?"
//        detailLabel.numberOfLines = 0
//        imageCardView.detailView = detailLabel
//        
//        // Yes button.
//        let btn1: FlatButton = FlatButton()
//        btn1.pulseColor = MaterialColor.cyan.lighten1
//        btn1.pulseScale = false
//        btn1.setTitle("YES", forState: .Normal)
//        btn1.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
//        
//        // No button.
//        let btn2: FlatButton = FlatButton()
//        btn2.pulseColor = MaterialColor.cyan.lighten1
//        btn2.pulseScale = false
//        btn2.setTitle("NO", forState: .Normal)
//        btn2.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
//        
//        // Add buttons to left side.
//        imageCardView.leftButtons = [btn1, btn2]
//        
//        // To support orientation changes, use MaterialLayout.
//        view.addSubview(imageCardView)
//        imageCardView.translatesAutoresizingMaskIntoConstraints = false
//        MaterialLayout.alignFromTop(view, child: imageCardView, top: 100)
//        MaterialLayout.alignToParentHorizontally(view, child: imageCardView, left: 20, right: 20)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

