//
//  ViewController.swift
//  DemoInAppPurchase
//
//  Created by Hoa Nguyen X. [2] VN.Danang on 01/07/2021.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    private var models: [SKProduct] = []
    enum Product: String, CaseIterable {
        case removeAds = "nxh.DemoInAppPurchase.removeAds"
        case unlockEverything = "nxh.DemoInAppPurchase.unlockEverything"
        case getGems = "nxh.DemoInAppPurchase.gems"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchProduct()
        SKPaymentQueue.default().add(self)
    }

    private func fetchProduct() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment)
    }
}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(product.localizedTitle) price:\(product.price)"
        return cell
    }
}

extension ViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.models = response.products
            self.tableView.reloadData()
        }
    }
}

extension ViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .deferred:
                print(".deferred")
            case .failed:
                print(".failed")
                SKPaymentQueue.default().finishTransaction($0)
            case .purchased:
                print(".purchased")
                SKPaymentQueue.default().finishTransaction($0)
            case .purchasing:
                print(".purchasing")
            case .restored:
                print(".restored")
            default: break
            }
        }
    }


}
