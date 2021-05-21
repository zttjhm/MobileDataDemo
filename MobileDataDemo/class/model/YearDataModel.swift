//
//  YearDataModel.swift
//  MobileData
//
//  Created by jhm on 2021/5/21.
//

import Foundation
class YearDataModel {
    var exception:Bool //是否异常
    var year:String
    var quarters:[Record]
    var mobile_data:Double
    
    init(year:String) {
        self.year = year
        self.mobile_data = 0.0
        self.exception = false
        self.quarters = [Record]()
    }
    
    func addQuarter(quarter:Record) ->Void{
        self.mobile_data += quarter.volume_of_mobile_data.doubleValue
        self.quarters.append(quarter)
        if (self.quarters.count == 4) {
            self.quarters.sort(by: { (r1, r2) -> Bool in
                return r1.quarter.compare(r2.quarter) == ComparisonResult.orderedAscending
            })
            self.exception = !(self.quarters[0] <= self.quarters[1] &&
                                self.quarters[1] <= self.quarters[2] &&
                                self.quarters[2] <= self.quarters[3] )
        }
    }
    
    
    
}
