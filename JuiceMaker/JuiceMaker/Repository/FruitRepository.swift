//
//  FruitStore.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation
import RxSwift
import RxOptional

class FruitRepository {
    static let shared = FruitRepository()
    private(set) var fruitStock = [Fruit : Int]()
    private let initialStock = 10
    
    init() {
        Fruit.allCases.forEach { fruit in
            fruitStock.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        return Observable.just(self.fruitStock[fruit])
                .filterNil()
    }
    
    func increaseStock(of fruit: Fruit, count: Int) -> PublishSubject<Bool> {
        let increaseSuccess = PublishSubject<Bool>()
        guard let currentStock = fruitStock[fruit] else {
            increaseSuccess.onNext(false)
            return increaseSuccess
        }
        self.fruitStock.updateValue(currentStock + count, forKey: fruit)
        increaseSuccess.onNext(true)
        return increaseSuccess
    }
    
    @discardableResult
    func decreasStock(of fruit: Fruit, count: Int) -> PublishSubject<Bool> {
        let decreaseSuccess = PublishSubject<Bool>()
        guard let currentStock = fruitStock[fruit], currentStock > .zero else {
            decreaseSuccess.onNext(false)
            return decreaseSuccess
        }
        self.fruitStock.updateValue(currentStock - count, forKey: fruit)
        decreaseSuccess.onNext(true)
        return decreaseSuccess
    }
}
