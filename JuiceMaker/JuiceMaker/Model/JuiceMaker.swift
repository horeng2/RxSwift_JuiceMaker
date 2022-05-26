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
        return fruitRepository.readStock(of: fruit)
    }
    
    func makeJuice(_ juice: Juice) -> Observable<Juice?> {
        let juiceObservable = self.canMake(juice: juice)
            .map{ $0.contains(false) ? false : true }
            .map{ $0 == true ? juice : nil }
            .do(onNext: { juice in
                guard let juice = juice else {
                    return
                }
                self.takeFruitStock(for: juice)
            })
        
        return juiceObservable
    }
    
    private func canMake(juice: Juice) -> Observable<[Bool]> {
        var canMake = [Bool]()
        
        juice.recipe.forEach { (fruit, count) in
            fruitRepository.readStock(of: fruit)
                .map{ $0 >= count }
                .subscribe(onNext: { canMake.append($0) })
                .disposed(by: diposeBag)
        }
        return Observable.just(canMake)
    }
    
    private func takeFruitStock(for juice: Juice) {
        juice.recipe.forEach { (fruit, count) in
            fruitRepository.decreaseStock(of: fruit, count: count)
        }
    }
    
    func modifyFruitStock(for fruit: Fruit, newQuantity: Int) -> Observable<Bool> {
        return fruitRepository.modifyStock(of: fruit, to: newQuantity)
    }
}
