//
//  ViewController.swift
//  ExpandCellDemo
//
//  Created by APP技術部-陳冠志 on 2019/8/15.
//  Copyright © 2019 Bruce Chen. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    var isExpand: Bool = false
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    let titleArray: [String] = ["NAME", "AGE", "EMAIL", "TEL", "LOCATION"]
    let detailArray: [String] = ["abcdefghijklmnopqrstuvwxyzabcd", "26", "XXXXXX@gmail.com", "XXXXXXXXXXX", "JP"]
    let hiddenArray: [Bool] = [false, true, true, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        loadLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let index = IndexPath(row: 0, section: 0)
        let cell: TestTableViewCell = self.tableView.cellForRow(at: index) as! TestTableViewCell
    
        print("frame : \(cell.subtitleLabel.frame)")
        print("width : \(cell.subtitleLabel.frame.width)")
        
        self.width = cell.subtitleLabel.frame.width
        self.height = cell.subtitleLabel.frame.height
    }
    
    fileprivate func tableviewSetting() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.register(TestButtonTableViewCell.self, forCellReuseIdentifier: "TestButtonTableViewCell")
        self.tableView.register(TestTableViewCell.self, forCellReuseIdentifier: "TestTableViewCell")
    }
    
    fileprivate func loadUI() {
        
        self.tableviewSetting()
        
        self.view.addSubview(tableView)
    }
    
    fileprivate func loadLayout() {
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc func expandBtnPressed(sender: UIButton) {
        
        guard sender.tag == 0 else { return }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            self.isExpand = !isExpand
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
    
    func isTruncated(label: UILabel, containerFrame: CGSize) -> Bool {
        let text = label.text ?? ""
        let estimatedSize = NSString(string: text).boundingRect(with: .init(width: 100000, height: containerFrame.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : label.font!], context: nil)
        return estimatedSize.width > containerFrame.width
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
            cell1.titleLabel.text    = self.titleArray[indexPath.row]
            cell1.subtitleLabel.text = self.detailArray[indexPath.row]
            
            let bool = cell1.subtitleLabel.isTruncated()
            let count = cell1.subtitleLabel.numberOfLines
            let count2 = cell1.subtitleLabel.calculateMaxLines()

            print("bool : \(bool)")
            print("count : \(count)")
            print("count2 : \(count2)")
            
            let bool2 = self.isTruncated(label: cell1.subtitleLabel, containerFrame: .init(width: self.width, height: self.height))
            print("bool2 : \(bool2)")

            let bool3 = cell1.subtitleLabel.isTruncated(containerFrame: .init(width: self.width, height: self.height))
            print("bool3 : \(bool3)")
            return cell1
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestButtonTableViewCell", for: indexPath) as! TestButtonTableViewCell
        cell.titleLabel.text    = self.titleArray[indexPath.row]
        cell.subtitleLabel.text = self.detailArray[indexPath.row]
        cell.button.isHidden    = self.hiddenArray[indexPath.row]
        cell.button.tag = indexPath.row

        if cell.subtitleLabel.isTruncated() && indexPath.row == 0 {
            
            cell.button.isHidden = false
            cell.subtitleLabel.adjustsFontSizeToFitWidth = false
            cell.button.addTarget(self, action: #selector(expandBtnPressed), for: .touchUpInside)
            
            if isExpand {
                cell.button.setImage(nil, for: .normal)
                cell.button.setTitle("close", for: .normal)
                cell.button.titleEdgeInsets.left = 0
                cell.subtitleLabel.numberOfLines = 0
            } else {
                cell.button.setImage(nil, for: .normal)
                cell.button.setTitle("open", for: .normal)
                cell.button.titleEdgeInsets.left = 0
                cell.subtitleLabel.numberOfLines = 1
            }
            
            cell.remakeLayout(isExpand: isExpand)
            
        } else if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 {
            
            cell.subtitleLabel.adjustsFontSizeToFitWidth = true
            cell.subtitleLabel.numberOfLines = 1
            cell.button.setTitle("modify", for: .normal)
        }
        
        return cell
    }
    
}

extension UILabel {
    
    func countLabelLines() -> Int {
        self.layoutIfNeeded()
        let myText = self.text! as NSString
        let attributes = [NSAttributedString.Key.font : self.font!]
        
        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
    
    func isTruncated() -> Bool {
        
        if (self.countLabelLines() > self.numberOfLines) {
            print("lines         : \(self.countLabelLines())")
            print("numberOfLines : \(self.numberOfLines)\n")
            return true
        }
        return false
    }
    
    func numberOfLines() -> Int {
        let textSize = CGSize(width: self.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(self.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func isTruncated(containerFrame: CGSize) -> Bool {
        let text = self.text ?? ""
        let estimatedSize = NSString(string: text).boundingRect(with: .init(width: 100000, height: containerFrame.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.font!], context: nil)
        return estimatedSize.width > containerFrame.width
    }
    
}
