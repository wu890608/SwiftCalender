
//
//  CalenderModel.swift
//  SwiftCalender
//
//  Created by 河南 on 16/10/10.
//  Copyright © 2016年 Demo. All rights reserved.
//

import UIKit

class CalenderModel: NSObject {
    
    var timeStr : NSString?;
    
    var dayDataAry : NSMutableArray = NSMutableArray();
    
    var dayNumber : NSInteger = 0{
    
        didSet{
            
            for index in 1...dayNumber {
                dayDataAry.addObject(index);
            }
            
        }
        
    };
    
    var firstDayForWeekDay : NSInteger = 1{
    
        didSet{
            
            for _ in 1..<firstDayForWeekDay {
                
                dayDataAry.insertObject("", atIndex: 0);
                
            }
            
        }
    
    };
    
    
}
