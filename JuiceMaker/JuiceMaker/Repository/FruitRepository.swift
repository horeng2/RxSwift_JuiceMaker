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
    private var fruitStock: Observable<[Fruit : Int]>
    static let initialStock = 10
    static let maximumStock = 100
    
    init() {
        var initialFruitStocks = [Fruit : Int]()
        Fruit.allCases.forEach { fruit in
            initialFruitStocks.updateValue(FruitRepository.initialStock, forKey: fruit)
        }
        self.fruitStock = Observable.just(initialFruitStocks)
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        return self.fruitStock
            .flatMap{ stocks in
            Observable.just(stocks[fruit])
                .compactMap{ $0 }
        }
    }
    
    func updateStock(of fruit: Fruit, to newQuantity: Int) -> Observable<Bool> {
        let newStocks = self.fruitStock.map{ stocks -> [Fruit: Int] in
            var newStocks = stocks
            newStocks.updateValue(newQuantity, forKey: fruit)
            return newStocks
        }
        self.fruitStock = newStocks
        
        return Observable.just(true)
    }
    
    func decreaseStock(of fruit: Fruit, count: Int) {
        self.readStock(of: fruit).map{ currentStock in
            guard currentStock == .zero else {
                return
            }
            self.updateStock(of: fruit, to: currentStock - count)
        }
      
    }
}
