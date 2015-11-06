//
//  ViewController.swift
//  WrtWifiCar
//
//  Created by Microduino on 11/3/15.
//  Copyright © 2015 Microduino. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZMRockerDelegate,UIWebViewDelegate {
  
    
    var camClient:TCPClient!
    var wrtClient:TCPClient!
    var Rocker:ZMRocker!
    var webView: UIWebView!
    let forWard = "FORWARD";
    let backWard = "BACKWARD";
    let leftTurn = "TURNLEFT";
    let rightTurn = "TURNRIGHT";
    let stop = "CARSTOP";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1);
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 36.0/255.0, green: 190.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        self.title = "WrtWifiCar";
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        let btn1=UIButton(frame: CGRectMake(0, 0, 50, 30))
        btn1.setTitle("设置", forState: UIControlState.Normal)
        btn1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn1.addTarget(self, action:"goSetting:", forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem=item2
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.titleTextAttributesForState(UIControlState.Normal);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "StatusChange:", name: "StatusChange", object: nil)
        
        
        createRocker();
        //创建socket
        camClient = TCPClient(addr: "192.168.1.1", port:8080)
        wrtClient = TCPClient(addr: "192.168.1.1", port:2001)
        //连接
        wrtClient.connect(timeout: 1);
        let (success,errmsg)=camClient.connect(timeout: 1)
        if(success){
           print(errmsg);
            webView.loadRequest(NSURLRequest(URL: NSURL(string:"http://192.168.1.1:8080")!))
        }
    }
    
    func createRocker(){
    
        let Rocker = ZMRocker(frame:CGRectMake((self.view.frame.width-234)/2,self.view.frame.height/2+80,234,234));
        Rocker.delegate = self;
        self.view.addSubview(Rocker);
        
        webView = UIWebView(frame:CGRectMake(0,64,self.view.frame.width,(self.view.frame.height-64)/2));
        webView.delegate=self
        webView.scalesPageToFit = true
        webView.scrollView.scrollEnabled = false;
        self.view.addSubview(webView);
        
    }
    func goSetting(sender:UIButton){
    
    
        self.navigationController?.pushViewController(SettingViewController(), animated:true);
    
    }
    
    func StatusChange(title:NSNotification)
    {
        let isOn = title.object as! Bool;
        print(isOn)
        if(isOn){
            webView.hidden = false;
        }else{
            webView.hidden = true;
        }
        
    }

    
    func rockerDidChangeDirection(rocker: ZMRocker!) {
        
        switch rocker.direction.rawValue {
        case 0:
            wrtClient.send(str:leftTurn+"\n" )
        case 1:
            wrtClient.send(str:forWard+"\n")
        case 2:
            wrtClient.send(str:rightTurn+"\n" )
        case 3:
            wrtClient.send(str:backWard+"\n" )
        default:
            wrtClient.send(str:stop+"\n" )
        }
    }
  
    //连接改变时
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        let rurl =  request.URL?.absoluteString
        if (rurl!.hasPrefix("ios:")){
            let method =  rurl!.componentsSeparatedByString("@")[1]
            if method == "signin_go"{
                signin_go()
            }
            return false
        }
        return true
    }
    func signin_go(){
        NSLog("-我执行了signin_go-")
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

