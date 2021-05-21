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
    var dataSource:[YearDataModel]?
    var tableView:UITableView?
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setupUI()
        self.initDataSource()
        // Do any additional setup after loading the view.
    }
    
    //初始化数据源
    func initDataSource()->Void {
        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
        let testReq = HMURLRequest<Bean>("/api/action/datastore_search",param,.GET)
        testReq.startWithSuccess(success: { (bean) in
            self.handleProcBean(bean: bean)
        }, fail: { (any) in
            if (any is Bean) {
                
            } else {
                
            }
        }) { (error) in
            self.view.makeToast(error.localizedDescription)
        }


    }
    
    func handleProcBean(bean:Bean)->Void {
       
        var map = [String:YearDataModel]()
        for node in bean.result.records {
            let strYear:String = String((node.quarter.prefix(4)))
            if (!strYear.isEmpty) {
                var model = map[strYear]
                if (model == nil) {
                    model = YearDataModel(year: strYear)
                    map[strYear] = model
                }
                (model!).addQuarter(quarter: node)
            }
 
        }
        //排序年
        dataSource = [YearDataModel](map.values).sorted(by: { (y1, y2) -> Bool in
            return y1.year.compare(y2.year) == .orderedAscending
        })
        //过滤不完整季度的数据
        dataSource = dataSource?.filter({ (model) -> Bool in
            let year = Int(model.year)
            let range = (2008...2018)
            return model.quarters.count == 4 && (range.contains(year!))
        })
 
        self.tableView?.reloadData()
   
      
    }


    func setupUI()->Void {
        self.tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        self.view.addSubview(self.tableView!)
        self.tableView?.register(YearConsumptionCell.self, forCellReuseIdentifier: "YearConsumptionCell")
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
        
    }

   
 

}


extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataSource?[indexPath.row]
        if (model != nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier:"YearConsumptionCell" , for: indexPath) as! YearConsumptionCell
            cell.yearLable?.text = model?.year
            cell.numLabel?.text = "\(model?.mobile_data ?? 0.0)"
            cell.backgroundColor = (model?.exception)! ? UIColor.red : UIColor .white
          
            return cell
        }
        return UITableViewCell()
       
        
       
    }
    
    
}


