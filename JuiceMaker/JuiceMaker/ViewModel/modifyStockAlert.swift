//
//  modifyStockAlert.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/26.
//

import Foundation

enum ModifyStockAlert {
    var message: String {
        switch self {
        case .minimumStock:
            return "더이상 줄일 수 없습니다👾"
        case .maximumStock:
            return "재고가 최대값입니다. 배불러요🐷"
        }
    }
    
    case minimumStock
    case maximumStock
}
