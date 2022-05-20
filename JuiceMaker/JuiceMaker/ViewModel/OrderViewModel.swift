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
    let fruitStock = BehaviorRelay<[Fruit: Int]>(value: FruitStore.shared.fruitStock)
    
    let disposeBag = DisposeBag()

    struct Input {
        let viewWillAppear: Observable<Void>
//        let orderStrawberryBananaButtonTap: Observable<Void>
//        let orderOfMangoKiwiButtonTap: Observable<Void>
//        let orderOfStrawberryButtonTap: Observable<Void>
//        let orderOfBananaButtonTap: Observable<Void>
//        let orderOfPineappleButtonTap: Observable<Void>
//        let orderOfKiwiButtonTap: Observable<Void>
//        let orderOfMangoButtonTap: Observable<Void>
    }
    
    struct Output {
        var currentStock: Driver<[Fruit: Int]>
//        var bananaStock: Driver<Int>
//        var pineappleStock: Driver<Int>
//        var kiwiStock: Driver<Int>
//        var mangoStock: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        let currentStock = fruitStock.asDriver()
        
//        let bananaStock = fruitStock
//            .map{ $0.filter{ $0.key == .banana } }
//            .asDriver(onErrorJustReturn: [.banana: 0])
//        let pineappleStock = fruitStock
//            .map{ $0.filter{ $0.key == .pineapple } }
//            .asDriver(onErrorJustReturn: [.pineapple: 0])
//        let kiwiStock = fruitStock
//            .map{ $0.filter{ $0.key == .kiwi } }
//            .asDriver(onErrorJustReturn: [.kiwi: 0])
//        let mangoStock = fruitStock
//            .map{ $0.filter{ $0.key == .mango } }
//            .asDriver(onErrorJustReturn: [.mango: 0])
            
            return Output(currentStock: currentStock)
    }
}

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
