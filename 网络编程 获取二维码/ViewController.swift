//
//  ViewController.swift
//  网络编程 获取二维码
//
//  Created by 麦志超 on 17/2/5.
//  Copyright (c) 2017年 mzc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabelCity: UILabel!
    
    @IBOutlet weak var nameLabelTemp: UILabel!
    
    @IBOutlet weak var nameLabelWeather: UILabel!
    
    @IBOutlet weak var nameImageViewShow: UIImageView!
    
    
    @IBOutlet weak var nameLabelExchangeRate: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK:请求API
        // MARK:加载二维码
        let url:NSURL = NSURL(string: "http://api.k780.com:88/?app=qr.get&data=mzc&level=h&size=10")!
        
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue())
            { (_, data, e) -> Void in
            if(e == nil)
            {
                //更新UI在主线程里面
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.nameImageViewShow.image = UIImage(data: data)

                })
                
                
            }
        }
        
        // MARK:加载天气
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: "http://api.k780.com:88/?app=weather.today&weaid=shenzhen&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")!), queue: NSOperationQueue()) { (_, data, e) -> Void in
            if e == nil
            {
                if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                {
                    let result = json.valueForKey("result") as! NSDictionary
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.nameLabelCity.text = result["citynm"] as? String
                        self.nameLabelWeather.text = "今天: " + (result["days"] as? String)! + " " + (result["weather"] as? String)!
                        self.nameLabelTemp.text = result["temperature"] as? String

                    })
                   
                }
            }
        }
        
        // MARK:加载汇率
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL:NSURL(string: "http://api.k780.com:88/?app=finance.rate&scur=USD&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4")!), queue: NSOperationQueue()) { (_, data, e) -> Void in
            if e == nil
            {
              if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
              {
                let result = json.valueForKey("result") as! NSDictionary
                let showRate:String = (result["ratenm"] as? String)! + " 的汇率是：" + (result["rate"] as? String)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.nameLabelExchangeRate.text = showRate
                    
                })
                
              }
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

