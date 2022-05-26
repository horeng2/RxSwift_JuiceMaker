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
            return "재고가 바닥났어요📦"
        case .maximumStock:
            return "재고가 꽉찼습니다. 배불러요🐷"
        }
    }
    
    case minimumStock
    case maximumStock
}
