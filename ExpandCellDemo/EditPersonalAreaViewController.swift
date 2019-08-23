//
//  EditPersonalAreaViewController.swift
//  TDCCePassbook
//
//  Created by Hans Hsu on 2018/6/9.
//  Copyright © 2018年 leechienting. All rights reserved.
//

import UIKit
import RxSwift

class EditPersonalAreaViewController: TDCCeBaseViewController {
    
    enum EditPersonalRowType {
        case Name
        case Identify
        case Birthday
        case Email
        case Phone
        case LoginCode
        
        func getEditPersonalInfo(value:String) -> EditPersonalInfo {
            switch self {
            case .Name:
                return ("姓名",value,false)
            case .Identify:
                return ("身分證字號",value,false)
            case .Birthday:
                return ("生日",value,false)
            case .Email:
                return ("Email",value,true)
            case .Phone:
                return ("行動電話",value,true)
            case .LoginCode:
                return ("密碼",value,true)
            }
        }
    }
    
    typealias EditPersonalInfo = (title:String,value:String,canEdit:Bool)
    
    let bag = DisposeBag()
    var personalData:[EditPersonalRowType] = [.Name,.Identify,.Birthday,.Email,.Phone,.LoginCode]
    var editDatas:[EditPersonalInfo]?
    var itemSources:Observable<[EditPersonalInfo]>?
    var au008Response:AU008Response
    
    let contentView: UIView = {
        let ui = UIView()
        ui.backgroundColor = UIColor.white
        ui.layer.masksToBounds = true
        ui.tdcc_ext_makeRounder(cornerRadius: 5)
        return ui
    }()
    
    var tableView: UITableView = {
        let ui = UITableView()
        ui.separatorStyle = .none
        ui.backgroundColor = .clear
        return ui
    }()
    
    var isExpand: Bool = false
    
    var personalArray:Array<Any>
    
    init(personalArray:Array<Any>,au008Response:AU008Response) {
        self.personalArray = personalArray
        self.au008Response = au008Response
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "個人資料"
        self.loadUI()
        self.loadLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.callAU008()
        
        TDCC_Tools.traceGoogleAnalyticsRecord(pageName: "個人資料", eventCategory: nil, eventAction: nil, eventLabel: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func tableViewSetting() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 75
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(StockBookSingleDetailWithButtonTableViewCell.self, forCellReuseIdentifier: "StockBookSingleDetailWithButtonTableViewCell")
    }

    fileprivate func loadUI() {
        
        self.tableViewSetting()
        self.contentView.tdcc_ext_makeCardViewStyle()
        
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.tableView)
    }
    
    fileprivate func loadLayout() {
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(14)
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-14)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    /**
     點擊長戶名展開按鈕
     */
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
    
}

//MARK: - 資料處理
extension EditPersonalAreaViewController {
    
    fileprivate func transferData() {
        
        self.editDatas = [EditPersonalInfo]()
        var sum = 0
        for editType in self.personalData {
            self.editDatas?.append(editType.getEditPersonalInfo(value: personalArray[sum] as! String))
            sum = sum + 1
        }
    }
    
    func callAU008(){
        let vm = LoginViewModel()
        vm.getUserInfo(didComplete: { (au008Response, errorString) in
            if let au008Response = au008Response, let header = au008Response.responseHeader, let body = au008Response.responseBody {
                if header.returnCode == TDCC_Constants.returnCode_Success {
                    
                    //                    printBBLog("[SUCCESS] userID = \(body.userID) userName = \(body.userName) userID隱碼：\(body.userID_HiddenFormat) \(body.birthday) \(body.email_HiddenFormat) \(body.mobile_HiddenFormat)")
                    self.au008Response = au008Response
					
                    // 生日隱碼
                    let aryBirthdaySplit = body.birthday_HiddenFormat.components(separatedBy: "/")
                    var birthdayConvertResult = "\(aryBirthdaySplit[0])/**/**"
                    if aryBirthdaySplit[0].hasPrefix("0") {
                        let year = aryBirthdaySplit[0]
                        birthdayConvertResult = "\(year.substring(from: 1))/**/**"
                    }
                    
                    // 行動電話中間加上空白
                    var mobile = body.mobile_HiddenFormat
                    let idx1 = mobile.index(mobile.startIndex, offsetBy: 4)
                    let idx2 = mobile.index(mobile.startIndex, offsetBy: 8)
                    mobile.insert(" ", at: idx1)
                    mobile.insert(" ", at: idx2)
                    
                    self.personalArray = [self.personalArray[0], self.personalArray[1], birthdayConvertResult, body.email_HiddenFormat, mobile, body.lcChangeTime_DateFormat]
                    self.transferData()
                    
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
                            self.tableView.reloadData()
                        }
                    }

                } else {
                    // error
                    printLogWithError("returnCode = \(header.returnCode) returnMsg = \(header.returnMsg)")
                }
            } else {
                printLogWithError("au008Response is nil")
            }
        })
    }
    
}

//MARK: - setup view
extension EditPersonalAreaViewController {
    @objc func pushNext(sender: UIButton) {
        
        var nextViewCtrl:UIViewController?
        // GA事件
        var action = String()
        
        switch sender.tag {
        case 3:
            nextViewCtrl = EditEmailViewController.init(au008Response: (self.au008Response))
            action = "修改Email"
        case 4:
            nextViewCtrl = PhoneEditViewController.init(au008Response: (self.au008Response))
            action = "修改行動電話"
        case 5:
            nextViewCtrl = EditLoginCodeViewController()
            action = "修改密碼"
        default:
            break
        }
        
        TDCC_Tools.traceGoogleAnalyticsRecord(pageName: nil, eventCategory: "個人資料", eventAction: action, eventLabel: nil)
        
        if let tmpViewCtrl = nextViewCtrl {
            let navigationViewCtrl = UINavigationController.init(rootViewController: tmpViewCtrl)
            self.present(navigationViewCtrl, animated: true, completion: nil)
        }
    }
}

//MARK: - UITableViewDelegate
extension EditPersonalAreaViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.editDatas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let editDatas = self.editDatas else { return UITableViewCell() } //確保 editDatas 有值

        let cell = tableView.dequeueReusableCell(withIdentifier: "StockBookSingleDetailWithButtonTableViewCell", for: indexPath) as! StockBookSingleDetailWithButtonTableViewCell
        cell.backgroundColor = ((indexPath.row % 2) == 0) ? UIColor.init(hex: "EEF0F4") : UIColor.white
        cell.titleLabel.text = editDatas[indexPath.row].title
        cell.button.isHidden = !editDatas[indexPath.row].canEdit
        cell.button.tag = indexPath.row

        // 中文難字處理
        if editDatas[indexPath.row].value.hasPrefix("ttf:") == true {
            TDCC_Tools.shared.unregisterFont(forUserID: (self.au008Response.responseBody?.userID)!)
            cell.subtitleLabel.font = TDCC_Tools.shared.registerFont(forUserID: (self.au008Response.responseBody?.userID)!, fontSize: 24.0)
            if let aryttfName = self.editDatas?[indexPath.row].value.components(separatedBy: ":"), aryttfName.count > 1 {
                let ttfName = aryttfName[1]
                cell.subtitleLabel.text = ttfName
            }
        } else {
            cell.subtitleLabel.text = self.editDatas?[indexPath.row].value
        }
        
        //檢查名字是否過長需要顯示展開按鈕
        if cell.subtitleLabel.isTruncated() && indexPath.row == 0 {
            
            cell.button.isHidden = false
            cell.subtitleLabel.adjustsFontSizeToFitWidth = false
            cell.button.addTarget(self, action: #selector(expandBtnPressed), for: .touchUpInside)
            
            if isExpand {
                cell.button.setImage(nil, for: .normal)
                cell.button.setTitle("收回", for: .normal)
                cell.button.titleEdgeInsets.left = -25
                cell.subtitleLabel.numberOfLines = 0
            } else {
                cell.button.setImage(nil, for: .normal)
                cell.button.setTitle("看全部", for: .normal)
                cell.button.titleEdgeInsets.left = 0
                cell.subtitleLabel.numberOfLines = 1
            }
            
            cell.remakeLayout(isExpand: isExpand)
        
        } else if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 {
            
            cell.subtitleLabel.adjustsFontSizeToFitWidth = true
            cell.subtitleLabel.numberOfLines = 1
            cell.button.setImage(#imageLiteral(resourceName: "icon_small_edit"), for: .normal)
            cell.button.setTitle("", for: .normal)
            cell.button.addTarget(self, action: #selector(pushNext(sender:)), for: .touchUpInside)
        }

        return cell
    }
    
}
