//
//  YearConsumptionCell.swift
//  MobileData
//
//  Created by jhm on 2021/5/21.
//
import UIKit
import Foundation


class YearConsumptionCell : UITableViewCell {
    var yearLable:UILabel!
    var numLabel:UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    func setupUI()->Void {
        self.yearLable = UILabel(frame: CGRect(x: 8, y: 5, width: 100, height: 18));
        self.numLabel = UILabel(frame: CGRect(x: 8, y: 25, width: 320, height: 13));
        self.numLabel!.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(self.yearLable!)
        self.contentView.addSubview(self.numLabel!)
        
      
    }
}
