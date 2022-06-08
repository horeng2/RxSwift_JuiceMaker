//
//  OrderResult.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/25.
//

import Foundation

enum OrderResult {
    var message: String {
        switch self {
        case .orderSuccess:
            return "주스 주문 완료🥤"
        case .orderFailure:
            return "주문 실패! 재고가 부족해요💦"
        }
    }
    
    init(_ makeJuiceResult: Bool) {
        switch makeJuiceResult {
        case true:
            self = .orderSuccess
        case false:
            self = .orderFailure
        }
    }
    
    case orderSuccess
    case orderFailure
}
