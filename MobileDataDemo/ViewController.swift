//
//  ViewController.swift
//  MobileData
//
//  Created by jhm on 2021/5/21.
//
import Toast_Swift
import SwiftyJSON
import UIKit


class ViewController: UIViewController,YearConsumptionCellDelegate {

    var dataSource:[YearDataModel]?
    var tableView:UITableView?
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setupUI()
        self.initDataSource()
        // Do any additional setup after loading the view.
    }
    
    func onViewConsumption(model: YearDataModel) {
        let str = "\(model.year) \n descend"
        let alert = UIAlertController(title: "", message: str, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //初始化数据源
    func initDataSource()->Void {
        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
        let testReq = HMURLRequest<Bean>("/api/action/datastore_search",param,.GET)
        testReq.startWithSuccess(success: { (bean) in
            self.handleProcBean(bean: bean)
        }, fail: { (any,cause) in
            var str = ""
            switch(cause) {
            case .LogicError:
                str = "logic error"
            case .JsonFormatError:
                str = "serialization json error"
            case .ResponseError:
                str = "response nil"
            case .ServerError:
                let statusCode = (testReq.task?.response as? HTTPURLResponse)?.statusCode
                str = "server Error code:\(statusCode!)"
            }
            self.view.makeToast(str)
         
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
        self.title = "Demo"
        self.tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        self.view.addSubview(self.tableView!)
        self.tableView?.register(YearConsumptionCell.self, forCellReuseIdentifier: "YearConsumptionCell")
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "qingchu"), style: .plain, target: self, action:#selector(onRightItemAction))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

   @objc func onRightItemAction()->Void {
        let controller = UIAlertController(title: "Clear Cache", message: "Are you sure?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (act) in
            URLCache.shared.removeAllCachedResponses() //
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(ok)
        controller.addAction(cancel)
        self.present(controller, animated: true, completion: nil)

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
            cell.setModel(model: model!)
            cell.delegate = self;
            return cell
        }
        return UITableViewCell()
       
        
       
    }
    
    
}


