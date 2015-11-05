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
    
        let Rocker = ZMRocker(frame:CGRectMake((self.view.frame.width-234)/2,self.view.frame.height/2+100,234,234));
        Rocker.delegate = self;
        self.view.addSubview(Rocker);
        
        webView = UIWebView(frame:CGRectMake(0,20,self.view.frame.width,self.view.frame.height/2));
        webView.delegate=self
        webView.scalesPageToFit = true
        webView.scrollView.scrollEnabled = false;
        webView.scrollView.bounces = true;
        self.view.addSubview(webView);
        
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
  

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

