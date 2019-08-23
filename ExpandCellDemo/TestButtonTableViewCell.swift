//
//  StockBookSingleDetailWithButtonTableViewCell.swift
//  TDCCePassbook
//
//  Created by APP技術部-陳冠志 on 2019/6/13.
//  Copyright © 2019 leechienting. All rights reserved.
//

import UIKit

class TestButtonTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = { () -> UILabel in
        let ui = UILabel()
        ui.font = UIFont.systemFont(ofSize: 16)
        ui.translatesAutoresizingMaskIntoConstraints = false
        return ui
    }()
    
    let subtitleLabel: UILabel = { () -> UILabel in
        let ui = UILabel()
        ui.font = UIFont.systemFont(ofSize: 16)
        ui.numberOfLines = 1
        ui.adjustsFontSizeToFitWidth = false
        ui.lineBreakMode = .byTruncatingTail
        ui.translatesAutoresizingMaskIntoConstraints = false
        return ui
    }()
    
    let button: UIButton = { () -> UIButton in
        let ui = UIButton()
        ui.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.backgroundColor = UIColor.gray
        return ui
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        loadUI()
        loadLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadUI() {
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(button)
    }
    
    fileprivate func loadLayout() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(defaultfifteenPt)
            make.left.equalTo(defaultfifteenPt)
            make.width.equalTo(defaultNinetyTwoPt)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalTo(titleLabel.snp.right)
            make.bottom.equalTo(-defaultfifteenPt)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalTo(subtitleLabel.snp.right)
            make.right.equalTo(-defaultFivePt)
            make.width.equalTo(defaultFiftyPt)
            make.height.equalTo(defaultTwentyPt)
        }
    }
    
    func remakeLayout(isExpand: Bool) {
        
        titleLabel.snp.removeConstraints()
        subtitleLabel.snp.removeConstraints()
        button.snp.removeConstraints()
        
        if isExpand {
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(defaultfifteenPt)
                make.left.equalTo(defaultfifteenPt)
                make.width.equalTo(defaultNinetyTwoPt)
            }
            
            subtitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.top)
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalTo(-defaultfifteenPt)
            }
            
            button.snp.makeConstraints { (make) in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(defaultFivePt)
                make.bottom.equalTo(-defaultFivePt)
                make.left.equalTo(subtitleLabel.snp.left)
                make.width.equalTo(defaultFiftyPt)
//                make.height.equalTo(defaultTwentyPt)
            }
            
        } else {
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(defaultfifteenPt)
                make.left.equalTo(defaultfifteenPt)
                make.width.equalTo(defaultNinetyTwoPt)
            }
            
            subtitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.top)
                make.left.equalTo(titleLabel.snp.right)
                make.bottom.equalTo(-defaultfifteenPt)
            }
            
            button.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.top)
                make.left.equalTo(subtitleLabel.snp.right)
                make.right.equalTo(-defaultFivePt)
                make.width.equalTo(defaultFiftyPt)
                make.height.equalTo(defaultTwentyPt)
            }
            
        }
        
    }
    
}
