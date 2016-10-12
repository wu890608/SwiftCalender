//
//  ViewController.swift
//  SwiftCalender
//
//  Created by 河南 on 16/10/10.
//  Copyright © 2016年 Demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let calender = SwiftCalender(frame: CGRectMake(0, 100, 320, 250));
        
        calender.customCellView = {(dayStr, view) -> Void in
            
            let label = UILabel(frame: CGRectMake(0, 0, view.frame.size.width , view.frame.size.height / 2));
            
            label.text = dayStr as String;
            
            label.textAlignment = .Center;
            
            label.font = UIFont.systemFontOfSize(12);
            
            view.addSubview(label);
            
            let label1 = UILabel(frame: CGRectMake(0, view.frame.size.height / 2, view.frame.size.width , view.frame.size.height / 2));
            
            label1.text = "¥998";
            
            label1.textAlignment = .Center;
            
            label1.font = UIFont.systemFontOfSize(10);
            
            view.addSubview(label1);
            
        
        };
        
        calender.selectCell = {(view) -> Void in
        
            print("123");
            
        };
        
        self.view.addSubview(calender);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

