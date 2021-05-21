//
//  YearConsumptionCell.swift
//  MobileData
//
//  Created by jhm on 2021/5/21.
//
import UIKit
import Foundation

 protocol YearConsumptionCellDelegate : NSObjectProtocol{
   func onViewConsumption(model:YearDataModel)
}

class YearConsumptionCell : UITableViewCell {
    var yearLable:UILabel!
    var numLabel:UILabel!
    var flagButton:UIButton!
    var _model:YearDataModel!;
    weak open var delegate:YearConsumptionCellDelegate?

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
        self.flagButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.size.width - 50, y: 5, width: 30, height: 30))
        self.flagButton.setImage(UIImage(named: "down"), for: UIControl.State.normal)
        self.numLabel!.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(self.yearLable!)
        self.contentView.addSubview(self.numLabel!)
        self.contentView.addSubview(self.flagButton!)
        self.flagButton.addTarget(self, action: #selector(onButtonClick(id:)), for: .touchUpInside);

    }
    
    @objc func onButtonClick(id:Any)->Void {
        self.delegate?.onViewConsumption(model: self._model)
    }
    
    func setModel(model:YearDataModel) ->Void {
        self._model = model
        self.yearLable?.text = model.year
        self.numLabel?.text = "\(model.mobile_data)"
        self.flagButton.isHidden = !model.exception
         
    }
}
