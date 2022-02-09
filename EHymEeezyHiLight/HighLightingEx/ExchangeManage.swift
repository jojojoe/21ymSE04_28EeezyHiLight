//
//  DataEncoding.swift
//  EHmmEaeezyHilight
//
//  Created by EaeezyHilight on 2022/1/24.
//  Copyright © 2022 Eaeezy. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class ExchangeManage: NSObject {
    class func exchangeWithSSK(objcetID: String, completion: @escaping (PurchaseResult) -> Void) {        
        SwiftyStoreKit.purchaseProduct(objcetID) { a in
            completion(a)
        }
    }
}
