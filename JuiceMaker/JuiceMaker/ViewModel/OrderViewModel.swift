//
//  OrderJuiceViewModel.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation
import RxSwift
import RxRelay

class OrderViewModel: ViewModelType {
    private let fruitStore = FruitStore.shared
    
    struct Input {
        var orderAction: Observable<Void>
    }
    
    struct Output {
        var currentStock: Int
    }
    
    func transform(input: Input) -> Output {
        return Output(currentStock: fruitStore.initialStock)
    }
    
    func reload() {
    }
    
}

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
