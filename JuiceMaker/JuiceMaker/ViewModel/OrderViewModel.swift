//
//  OrderJuiceViewModel.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class OrderViewModel: ViewModelType {
    private let fruitStore = FruitStore.shared
    let disposeBag = DisposeBag()

    struct Input {
        var orderStrawberryBananaButtonTap: Observable<Void>
        var orderOfMangoKiwiButtonTap: Observable<Void>
        var orderOfStrawberryButtonTap: Observable<Void>
        var orderOfBananaButtonTap: Observable<Void>
        var orderOfPineappleButtonTap: Observable<Void>
        var orderOfKiwiButtonTap: Observable<Void>
        var orderOfMangoButtonTap: Observable<Void>
    }
    
    struct Output {
        var currentStock: Driver<[Fruit:Int]>
    }
    
//    func transform(input: Input) -> Output {
//    }

    func reload() {
    }

}

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
//    func transform(input: Input) -> Output
}
