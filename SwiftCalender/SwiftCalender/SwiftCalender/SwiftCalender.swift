//
//  SwiftCalender.swift
//  SwiftCalender
//
//  Created by 河南 on 16/10/10.
//  Copyright © 2016年 Demo. All rights reserved.
//



import UIKit

typealias CustomCellView = (NSString,UIView) -> Void;
typealias SelectCell = (UIView) -> Void;
class SwiftCalender: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var customCellView : CustomCellView?;
    var selectCell : SelectCell?;
    
    let LYCalenderIdentifier = "LYCalenderCell";
    var KWidth : CGFloat = 0;
    var KHeight : CGFloat = 0;
    let KYearNum = 100;
    
    let dataAry = NSMutableArray();
    

    var collectionView :UICollectionView?;
    var timeLabel : UILabel?;
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.whiteColor();
        
        KWidth = self.frame.size.width;
        
        KHeight = self.frame.size.height;
        
        // 设置子视图
        self.customSubViews();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置子视图
    func customSubViews() -> Void {
        
        // 计算日期
        self.customDate();
        
        // 设置表头视图
        self.customHeaderView();
        
        // 初始化collectionView
        self.customCollectionView();

        
    }
    
    // 设置表头视图
    func customHeaderView() -> Void {
        
        let weekAry = ["周日","周一","周二","周三","周四","周五","周六"];
    
        for i  in 0..<7 {
            
            let frame = CGRectMake(CGFloat(i) * (KWidth / 7), KHeight / 8, KWidth / 7, KHeight / 7);
            
            let label = UILabel.init(frame: frame);
            
            label.text = weekAry[i];
            
            label.textColor = UIColor.lightGrayColor();
            
            label.textAlignment = .Center;
            
            label.font = UIFont.systemFontOfSize(12);
            
            self.addSubview(label);
            
        }
        
        timeLabel = UILabel(frame: CGRectMake(KWidth / 2 - 60,0,120,KHeight / 8));
        
        
        timeLabel?.font = UIFont.systemFontOfSize(12);
        
        timeLabel?.textAlignment = .Center;
        
        self.addSubview(timeLabel!);
        
        
    }
    
    
    // 初始化collectionView
    func customCollectionView() -> Void {
        
        var frame : CGRect = self.frame;
        
        frame.origin.x = 0;
        
        frame.origin.y = KHeight / 8 * 2;
        
        frame.size.height = frame.size.height / 8 * 6;
        
        let flowLayout = UICollectionViewFlowLayout.init();
        
        flowLayout.scrollDirection = .Vertical;
        
        flowLayout.minimumLineSpacing = 0;
        
        flowLayout.minimumInteritemSpacing = 0;
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0);
        
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: flowLayout);
        
        collectionView?.backgroundColor = UIColor.whiteColor();
        
        collectionView?.dataSource = self;
        
        collectionView?.delegate = self;
        
        collectionView?.pagingEnabled = true;
        
        self.addSubview(collectionView!);
        
        collectionView?.scrollToItemAtIndexPath( NSIndexPath(forItem: 0, inSection: KYearNum * 12 - 1), atScrollPosition: .Top, animated: false);
        
        collectionView?.registerClass(LYCalenderViewCell().classForCoder, forCellWithReuseIdentifier: LYCalenderIdentifier);
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let index = floor((collectionView?.contentOffset.y)! / (collectionView?.frame.size.height)!);
        
        let calenderModel : CalenderModel = dataAry[NSInteger(index)] as! CalenderModel;
        
        timeLabel?.text = calenderModel.timeStr as? String;
        
        
    }
    
    // collectionView 的代理方法
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataAry.count;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 42;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LYCalenderIdentifier, forIndexPath: indexPath);
        
        for view : UIView in cell.contentView.subviews {
            
            view.removeFromSuperview();
            
        }
        
        if (customCellView != nil) {
            
            let calenderModel : CalenderModel = dataAry[indexPath.section] as! CalenderModel;
            
            
            if indexPath.row <  calenderModel.dayDataAry.count && indexPath.row >= calenderModel.firstDayForWeekDay - 1{
                
                let view = UIView.init(frame: cell.contentView.frame);
                
                var frame = cell.contentView.frame;
                
                frame.size.width = frame.size.width / 6 * 4;
                
                frame.origin.x = frame.size.width / 6;
                
                frame.size.height = frame.size.height / 8 * 7;
                
                frame.origin.y = frame.size.height / 9;
                
                view.frame = frame;
                
                cell.contentView.addSubview(view);
                
                customCellView!("\(calenderModel.dayDataAry[indexPath.row])",view);

            }
            
        }
        
        return cell;
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (selectCell != nil) {
            
            
            let calenderModel : CalenderModel = dataAry[indexPath.section] as! CalenderModel;
            
            
            if indexPath.row <  calenderModel.dayDataAry.count && indexPath.row >= calenderModel.firstDayForWeekDay - 1{
            
                selectCell!((collectionView.cellForItemAtIndexPath(indexPath)?.contentView.subviews[0])!);
                
                
            }
            
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(KWidth / 7, KHeight / 8);
    }
    // 计算时间
    func customDate() -> Void {
        
        let date = NSDate();
        
        let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian);
        
        
        for index in 2...12 * KYearNum{
            
            let interval = (index - 1) * 24 * 60 * 60 * 35
            
            let newDate = date.dateByAddingTimeInterval(-Double(interval));
 
            let calenderModel = CalenderModel();
            
            let formatter = NSDateFormatter();
            
            formatter.dateFormat = "YYYY年MM月";
            
            calenderModel.timeStr = formatter.stringFromDate(newDate);
            
            calenderModel.dayNumber = (calender?.rangeOfUnit(.Day, inUnit: .Month, forDate: newDate).length)!;
            
            formatter.dateStyle = .MediumStyle;
            
            formatter.timeStyle = .NoStyle;
            
            formatter.timeZone = NSTimeZone.init(abbreviation: "UTC");
            
            formatter.dateFormat = "YYYY-MM";
            
            let YMStr = formatter.stringFromDate(newDate);
            
            formatter.dateFormat = "YYYY-MM-dd";
            
            
            let firstDate = formatter.dateFromString("\(YMStr)-01");
  
            calenderModel.firstDayForWeekDay = (calender?.component(.Weekday, fromDate: firstDate!))!;
            
            dataAry.insertObject(calenderModel,atIndex: 0);
            
        }
        
        for index in 1...12 * KYearNum{
            
            let interval = (index - 1) * 24 * 60 * 60 * 35
            
            let newDate = date.dateByAddingTimeInterval(Double(interval));
            
            let calenderModel = CalenderModel();
            
            let formatter = NSDateFormatter();
            
            formatter.dateFormat = "YYYY年MM月";
            
            calenderModel.timeStr = formatter.stringFromDate(newDate);
            
            calenderModel.dayNumber = (calender?.rangeOfUnit(.Day, inUnit: .Month, forDate: newDate).length)!;
            
            formatter.dateStyle = .MediumStyle;
            
            formatter.timeStyle = .NoStyle;
            
            formatter.timeZone = NSTimeZone.init(abbreviation: "UTC");
            
            formatter.dateFormat = "YYYY-MM";
            
            let YMStr = formatter.stringFromDate(newDate);
            
            formatter.dateFormat = "YYYY-MM-dd";
            
            let firstDate = formatter.dateFromString("\(YMStr)-01");
            
            calenderModel.firstDayForWeekDay = (calender?.component(.Weekday, fromDate: firstDate!))!;
            
            dataAry.addObject(calenderModel);
            
        }
        
    }
    
    
}
