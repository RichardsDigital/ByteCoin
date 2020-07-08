//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var currencyDisplay: UILabel!
    @IBOutlet weak var currencyLocationLabel: UILabel!
    @IBOutlet weak var chooseLocation: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        chooseLocation.dataSource = self
        chooseLocation.delegate = self
    }
}
//MARK: - CoinManagerDelegate
    
extension ViewController: CoinManagerDelegate {
        
        func didUpdatePrice(price: String) {
            DispatchQueue.main.async {
                self.currencyDisplay.text = price
            }
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }
    }
    
//MARK: - UIPickerview Datasource & Delegate
    
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyLocationLabel.text = coinManager.currencyArray[row]
        if let selectedLocation = String?(coinManager.currencyArray[row]){
            coinManager.createURL(selectedLocation: selectedLocation)
            self.currencyLocationLabel.text = String?(coinManager.currencyArray[row])
            
        }
        
        }
}


    
    
    


