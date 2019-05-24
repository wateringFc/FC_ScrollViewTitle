//
//  FC_LevelViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/24.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

public enum LeveType {
    case LeveType_highest /// 高危
    case LeveType_high /// 危险
    case LeveType_general /// 一般
}

class FC_LevelViewController: UIViewController {

    var type: LeveType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        switch type {
        case .LeveType_highest?:
            view.backgroundColor = .cyan
            break
        case .LeveType_high?:
            view.backgroundColor = .orange
            break
        case .LeveType_general?:
            view.backgroundColor = .gray
            break
        default:
            break
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
