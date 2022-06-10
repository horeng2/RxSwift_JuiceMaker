//
//  JuiceMaker.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/23.
//

import Foundation
import RxSwift

struct JuiceMaker {
    private let fruitRepository = FruitRepository.shared
    private let diposeBag = DisposeBag()
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return self.fruitRepository.readStock(of: fruit)
    }
    
    func makeJuice(_ juice: Juice) -> Observable<Bool> {
        let juiceObservable = self.haveFruitStock(to: juice)
            .map{ haveEnoughFruits in
                haveEnoughFruits.contains(false) ? false : true
            }
            .do(onNext: { canMakeJuice in
                guard canMakeJuice else {
                    return
                }
                self.takeFruitStock(for: juice)
            })
        
        return juiceObservable
    }
    
    private func haveFruitStock(to juice: Juice) -> Observable<[Bool]> {
        var canMake = [Bool]()
        
        juice.recipe.forEach { (fruit, count) in
            self.fruitRepository.readStock(of: fruit)
                .map{ $0 >= count }
                .subscribe(onNext: { canMake.append($0) })
                .disposed(by: self.diposeBag)
        }
        
        return Observable.just(canMake)
    }
    
    private func takeFruitStock(for juice: Juice) {
        juice.recipe.forEach { (fruit, count) in
            self.fruitRepository.decreaseStock(of: fruit, count: count)
        }
    }
    
    func updateFruitStock(for fruit: Fruit, newQuantity: Int) {
        self.fruitRepository.updateStock(of: fruit, to: newQuantity)
    }
}
