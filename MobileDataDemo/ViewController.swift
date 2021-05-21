//
//  ViewController.swift
//  MobileData
//
//  Created by jhm on 2021/5/21.
//
import Toast_Swift
import SwiftyJSON
import UIKit


class ViewController: UIViewController {
  
    var tableView:UITableView?
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
     

       // self.initDataSource()
        // Do any additional setup after loading the view.
    }
    
    
    func initDataSource()->Void {
        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
        let testReq = HMURLRequest<Bean>("/api/action/datastore_search",param,.GET)
        testReq.startWithSuccess(success: { (bean) in
        
        }, fail: { (any) in
            
        }) { (error) in
         
        }


    }
    
   
    
    
}


