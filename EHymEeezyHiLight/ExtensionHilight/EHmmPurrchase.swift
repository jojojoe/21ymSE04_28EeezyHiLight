//
//  EHmmPurrchase.swift
//  EHymEeezyHiLight
//
//  Created by Joe on 2022/1/20.
//

import Foundation

import Foundation
import SwiftyStoreKit
import StoreKit
import NoticeObserveKit
import Alamofire
import ZKProgressHUD


class EHmmInCyStoreItem {
    var id: Int = 0
    var iapId: String = ""
    var coin: Int  = 0
    var price: String = ""
    var localPrice: String?
    init(id: Int, iapId: String, coin: Int, price: String) {
        self.id = id
        self.iapId = iapId
        self.coin = coin
        self.price = price
        
    }
}

extension Notice.Names {
    
    static let pi_noti_coinChange = Notice.Name<Any?>(name: "ehdipihallo_noti_coinChange")
    static let pi_noti_priseFetch = Notice.Name<Any?>(name: "ehdipihallo_noti_priseFetch")
    
}

class GPyymCoinManagr: NSObject {
    var coinCount: Int = 0
    var coinIpaItemList: [EHmmInCyStoreItem] = []
    
    static let `default` = GPyymCoinManagr()
    let coinFirst: Int = 0
    let coinCostCount: Int = 200
    let k_localizedPriceList = "EHPyStoreItem.localizedPriceList"
    var currentBuyModel: EHmmInCyStoreItem?
    var purchaseCompletion: ((Bool, String?)->Void)?
    
    
    override init() {
        // coin count
        super.init()
        addObserver()
        loadDefaultData()
    }
    deinit {
        removeObserver()
    }
    func loadDefaultData() {
        
        #if DEBUG
        KeychainSaveManager.removeKeychainCoins()
        #endif
        
        if KeychainSaveManager.isFirstSendCoin() {
            coinCount = coinFirst
        } else {
            coinCount = KeychainSaveManager.readCoinFromKeychain()
        }
        
        // iap items list
        
        let iapItem0 = EHmmInCyStoreItem.init(id: 0, iapId: "com.ezycover.storyhighlight.listone", coin: 100, price: "1.99")
        let iapItem1 = EHmmInCyStoreItem.init(id: 1, iapId: "com.ezycover.storyhighlight.listtwo", coin: 300, price: "2.99")
        let iapItem2 = EHmmInCyStoreItem.init(id: 2, iapId: "com.ezycover.storyhighlight.listthree", coin: 500, price: "3.99")
        let iapItem3 = EHmmInCyStoreItem.init(id: 3, iapId: "com.ezycover.storyhighlight.listfour", coin: 800, price: "4.99")
        let iapItem4 = EHmmInCyStoreItem.init(id: 4, iapId: "com.ezycover.storyhighlight.listfive", coin: 1000, price: "6.99")
        let iapItem5 = EHmmInCyStoreItem.init(id: 5, iapId: "com.ezycover.storyhighlight.listsix", coin: 3000, price: "8.99")
        let iapItem6 = EHmmInCyStoreItem.init(id: 6, iapId: "com.ezycover.storyhighlight.listseven", coin: 4000, price: "9.99")
        let iapItem7 = EHmmInCyStoreItem.init(id: 7, iapId: "com.ezycover.storyhighlight.listeight", coin: 6000, price: "10.99")
        
        
        coinIpaItemList = [iapItem0, iapItem1, iapItem2, iapItem3, iapItem4, iapItem5, iapItem6, iapItem7]
        loadCachePrice()
        fetchPrice()
    }
    
    func costCoin(coin: Int) {
        coinCount -= coin
        saveCoinCountToKeychain(coinCount: coinCount)
    }
    
    func addCoin(coin: Int) {
        coinCount += coin
        saveCoinCountToKeychain(coinCount: coinCount)
    }
    
    func saveCoinCountToKeychain(coinCount: Int) {
        KeychainSaveManager.saveCoinToKeychain(iconNumber: "\(coinCount)")
        
        Notice.Center.default.post(name: .pi_noti_coinChange, with: nil)
        
    }
    
    func loadCachePrice() {
        
        if let localizedPriceDict = UserDefaults.standard.object(forKey: k_localizedPriceList) as?  [String: String] {
            for item in self.coinIpaItemList {
                if let price = localizedPriceDict[item.iapId] {
                    item.localPrice = price
                }
            }
        }
    }
    
    func fetchPrice() {
        
        let iapList = coinIpaItemList.compactMap { $0.iapId }
        SwiftyStoreKit.retrieveProductsInfo(Set(iapList)) { [weak self] result in
            guard let `self` = self else { return }
            let priceList = result.retrievedProducts.compactMap { $0 }
            var localizedPriceList: [String: String] = [:]
            
            for (index, item) in self.coinIpaItemList.enumerated() {
                let model = priceList.filter { $0.productIdentifier == item.iapId }.first
                if let price = model?.localizedPrice {
                    self.coinIpaItemList[index].localPrice = price
                    localizedPriceList[item.iapId] = price
                }
            }

            //TODO: 保存 iap -> 本地price
            UserDefaults.standard.set(localizedPriceList, forKey: self.k_localizedPriceList)
            
            Notice.Center.default.post(name: .pi_noti_priseFetch, with: nil)
        }
    }
    
    func purchaseIapId(item: EHmmInCyStoreItem, completion: @escaping ((Bool, String?)->Void)) {
        self.purchaseCompletion = completion
        storeKitBuyCoin(item: item)
        
        
//        SwiftyStoreKit.purchaseProduct(iap) { [weak self] result in
//            guard let `self` = self else { return }
//            debugPrint("self\(self)")
//            switch result {
//            case .success:
//                Adjust.trackEvent(ADJEvent(eventToken: AdjustKey.AdjustKeyAppCoinsBuy.rawValue))
//                completion(true, nil)
//            case let .error(error):
////                HUD.error(error.localizedDescription)
//                completion(false, error.localizedDescription)
//            }
//        }
    }
    
    
    func storeKitBuyCoin(item: EHmmInCyStoreItem) {
        let netManager = NetworkReachabilityManager()
        netManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable :
                self.netWorkError()
                break
            case .unknown :
                self.netWorkError()
                break
            case .reachable(_):
                
                ZKProgressHUD.show()
                self.currentBuyModel = item
                self.validateIsCanBought(iapID: item.iapId)
                break
            }
        })
    }
    
    func netWorkError() {
        
        ZKProgressHUD.showError("The network is not reachable. Please reconnect to continue using the app.")
        
    }
   
     
    
    /*
    func track(_ event: String?, price: Double? = nil, currencyCode: String? = nil) {
        Adjust.appDidLaunch(ADJConfig(appToken: AdjustKey.AdjustKeyAppToken.rawValue, environment: ADJEnvironmentProduction))
        guard let event = event else { return }
        let adjEvent = ADJEvent(eventToken: event)
        if let price = price {
            adjEvent?.setRevenue(price, currency: currencyCode ?? "USD")
        }
        Adjust.trackEvent(adjEvent)
    }
    */
}
// Products StoreKit
extension GPyymCoinManagr: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func addObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    func removeObserver() {
        SKPaymentQueue.default().remove(self)
    }
    
        
    func validateIsCanBought(iapID: String) {
        if SKPaymentQueue.canMakePayments() {
            buyProductInfo(iapID: iapID)
        } else {
            ZKProgressHUD.dismiss()
            ZKProgressHUD.showError("Purchase Failed")
        }
    }
    
    func buyProductInfo(iapID: String) {
        let result = SKProductsRequest.init(productIdentifiers: [iapID])
        result.delegate = self
        result.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let productsArr = response.products
        
        if productsArr.count == 0 {
            
            DispatchQueue.main.async {
                ZKProgressHUD.dismiss()
                ZKProgressHUD.showError("Purchase Failed")
            }
            
            return
        }
        
        let payment = SKPayment.init(product: productsArr[0])
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        DispatchQueue.main.async {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    print("💩💩💩💩purchased")
                    ZKProgressHUD.dismiss()
                    // 购买成功
                    SKPaymentQueue.default().finishTransaction(transaction)
                    if let item = self.currentBuyModel {
                         
                        GPyymCoinManagr.default.addCoin(coin: item.coin)
//                        Adjust.trackEvent(ADJEvent(eventToken: AdjustKey.AdjustKeyAppCoinsBuy.rawValue))
//
//                        let priceStr = item.price.replacingOccurrences(of: "$", with: "")
//                        let priceFloat = priceStr.float() ?? 0
//
//                        AFlyerLibManage.event_PurchaseSuccessAll(symbolType: "$", needMoney: priceFloat, iapId: item.iapId)
                        
//                        self.track(AdjustKey.AdjustKeyAppCoinsBuy.rawValue, price: Double(price!), currencyCode: self.currencyCode)
                    }
                    self.purchaseCompletion?(true, nil)
                    break
                    
                case .purchasing:
                    print("💩💩💩💩purchasing")
                    break
                    
                case .restored:
                    print("💩💩💩💩restored")
                    ZKProgressHUD.dismiss()
                    ZKProgressHUD.showError(transaction.error?.localizedDescription)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    break
                    
                case .failed:
                    print("💩💩💩💩failed")
                    //交易失败
                    ZKProgressHUD.dismiss()
//                    ZKProgressHUD.showError(transaction.error?.localizedDescription)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    self.purchaseCompletion?(false, transaction.error?.localizedDescription)
                    break
                default:
                    break
                }
            }
        }
    }
}
