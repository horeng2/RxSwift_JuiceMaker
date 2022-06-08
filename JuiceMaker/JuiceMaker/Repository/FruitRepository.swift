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
    
    func readStock() -> Observable<[Fruit : Int]> {
        return Observable.just(self.fruitStock)
    }
    
    func updateStock(of fruit: Fruit, to newQuantity: Int) {
        self.fruitStock.updateValue(newQuantity, forKey: fruit)
    }
    
    func decreaseStock(of fruit: Fruit, count: Int) {
        guard let currentStock = self.fruitStock[fruit], currentStock > .zero else {
            return
        }
        self.fruitStock.updateValue(currentStock - count, forKey: fruit)
    }
}
