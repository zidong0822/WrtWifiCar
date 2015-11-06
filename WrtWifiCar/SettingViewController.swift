//
//  SettingViewController.swift
//  WrtWifiCar
//
//  Created by HeHongwe on 15/11/6.
//  Copyright © 2015年 Microduino. All rights reserved.
//

import UIKit

class SettingViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{


    var tableView : UITableView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1);
        self.title = "设置";
        
        initTableView();
       
    }

    
    //初始化tableview
    func initTableView(){
        // 初始化tableView的数据
        self.tableView=UITableView(frame:CGRectMake(0, 0,self.view.frame.width, self.view.frame.height),style:UITableViewStyle.Grouped)
        // 设置tableView的数据源
        self.tableView?.dataSource = self
        // 设置tableView的委托
        self.tableView!.delegate = self
        self.tableView?.tableFooterView = UIView();
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
    }
    //总行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 5;
    }
    //加载数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "newsCell")
        cell.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1);
        if(indexPath.row == 0){
        
            cell.textLabel?.text = "摄像头"
            let myswitch = UISwitch(frame:CGRectMake(cell.frame.size.width-20,10,100,40));
            myswitch.on = true;
            myswitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            cell.addSubview(myswitch);
        
        }
        
        return cell;
        
    }
    
    //选择一行
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
    }
    //行高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }

    func stateChanged(switchState: UISwitch) {
       print(switchState.on)
       NSNotificationCenter.defaultCenter().postNotificationName("StatusChange", object:switchState.on);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}