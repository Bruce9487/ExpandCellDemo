//
//  StockBookSingleDetailTableViewCell.swift
//  TDCCePassbook
//
//  Created by APP技術部-陳冠志 on 2019/6/13.
//  Copyright © 2019 leechienting. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = { () -> UILabel in
        let ui = UILabel()
        ui.font = UIFont.systemFont(ofSize: 16)
        ui.sizeToFit()
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
    
    func loadUI() {
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    func loadLayout() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(defaultfifteenPt)
            make.left.equalTo(defaultfifteenPt)
            make.width.equalTo(defaultNinetyTwoPt)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.left.equalTo(titleLabel.snp.right)
            make.bottom.equalTo(-defaultfifteenPt)
            make.right.equalTo(-defaultfifteenPt)
        }
        
    }
    
}
