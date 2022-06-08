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
    private var fruitStock: [Fruit : Int]
    static let initialStock = 10
    static let maximumStock = 100
    
    init() {
        var initialFruitStocks = [Fruit : Int]()
        Fruit.allCases.forEach { fruit in
            initialFruitStocks.updateValue(FruitRepository.initialStock, forKey: fruit)
        }
        self.fruitStock = initialFruitStocks
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        return self.fruitStock
            .flatMap{ stocks in
                Observable.just(stocks[fruit])
                    .compactMap{ $0 }
            }
    }
    
    func updateStock(of fruit: Fruit, to newQuantity: Int) {
        let newStocks = self.fruitStock.map{ stocks -> [Fruit : Int] in
            var newStocks = stocks
            newStocks.updateValue(newQuantity, forKey: fruit)
            return newStocks
        }
        self.fruitStock = newStocks
    }
    
    func decreaseStock(of fruit: Fruit, count: Int) {
        let newStocks = self.fruitStock.map{ stocks -> [Fruit : Int] in
            guard let currentStock = stocks[fruit], currentStock > .zero else {
                return [Fruit: Int]()
            }
            var newStocks = stocks
            newStocks.updateValue(currentStock - count, forKey: fruit)
            return newStocks
        }
        self.fruitStock = newStocks
    }
}
