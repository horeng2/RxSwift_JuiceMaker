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
    static let maximumStock = 100
    
    init() {
        Fruit.allCases.forEach { fruit in
            fruitStock.updateValue(self.initialStock, forKey: fruit)
        }
    }
    
    func readStock(of fruit: Fruit) -> Observable<Int> {
        return Observable.just(self.fruitStock[fruit])
                .filterNil()
    }
    
    func modifyStock(of fruit: Fruit, to newQuantity: Int) -> Observable<Bool> {
        guard fruitStock[fruit] != nil else {
            return Observable.just(false)
        }
        self.fruitStock.updateValue(newQuantity, forKey: fruit)
        return Observable.just(true)
    }
    
    func decreaseStock(of fruit: Fruit, count: Int) {
        guard let currentStock = fruitStock[fruit], currentStock > .zero else {
            return
        }
        self.fruitStock.updateValue(currentStock - count, forKey: fruit)
    }
}
