//
//  FruitStore.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation
import RxSwift

class FruitRepository {
    static let shared = FruitRepository()
    private var fruitStock: BehaviorSubject<[Fruit : Int]>
    static let initialStock = 10
    static let maximumStock = 100
    
    init() {
        var initialFruitStocks = [Fruit : Int]()
        Fruit.allCases.forEach { fruit in
            initialFruitStocks.updateValue(FruitRepository.initialStock, forKey: fruit)
        }
        self.fruitStock = BehaviorSubject(value: initialFruitStocks)
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        return self.fruitStock
            .flatMap{ stocks in
            Observable.just(stocks[fruit])
                .compactMap{ $0 }
        }
    }
    
    func updateStock(of fruit: Fruit, to newQuantity: Int) -> Observable<Bool> {
        self.fruitStock.map{ stocks in
            var newStocks = stocks
            newStocks.updateValue(newQuantity, forKey: fruit)
            self.fruitStock.onNext(newStocks)
        }
        
        return Observable.just(true)
    }
    
    func decreaseStock(of fruit: Fruit, count: Int) {
        self.fruitStock.map{ stocks in
            guard let currentStock = stocks[fruit], currentStock > .zero else {
                return
            }
            self.updateStock(of: fruit, to: currentStock - count)
        }
      
    }
}
