//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Tim Krull on 07/12/2018.
//  Copyright © 2018 Tim Krull. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	//Base URL for API call to bitcoinaverage.com
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
	//Array of currencies supported
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
	//Final URL that will be used for the API call, Base URL + currency
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		currencyPicker.delegate = self
		currencyPicker.dataSource = self
    }//viewDidLoad()

    
	//MARK: - UIPicker Delegate Methods
	/***************************************************************/
	
	//Returns the number of columns in the UIPickerView
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}//numberOfComponents(in pickerView: UIPickerView) -> Int
	
	//Return the number of rows in the UIPickerView
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currencyArray.count
	}//pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
	
	//Returns the currently selected currency from the UIPickerView
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currencyArray[row]
	}//pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
	
	//Constructs the finalURL from the baseURL and the selected currency
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		finalURL = baseURL + currencyArray[row]
		getBitcoinValue()
	}//pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    
	
    //MARK: - Networking
    /***************************************************************/
	
	//gets the Bitcoin value in the selected currency from bitcoinaverage.com using Alamofire
	//passes the JSON from the API call to updateTicker method
    func getBitcoinValue() {
		
		//Make the API call
        Alamofire.request(finalURL, method: .get)
            .responseJSON { response in
				//if call is successful
                if response.result.isSuccess {

                    //get the JSON data from the response
                    let valueJSON : JSON = JSON(response.result.value!)
					
					//pass the JSON to updateTicker method
                    self.updateTicker(json: valueJSON)

					
                }
				//if the call is not successful
				else {
					//update bitcoinPriceLabel to let user know there are connection issues
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }//getBitcoinValue()
	
	
    //MARK: - JSON Parsing
    /***************************************************************/
	
	//Pulls the value data from the JSON and updates bitcoinPriceLabel with it
    func updateTicker(json : JSON) {
		
		//if the value exists
        if let valueResult = json["last"].double {
			//update the label with the Bitcoin Value
			bitcoinPriceLabel.text = "\(valueResult)"
			
		}
		//if the value doesn't exist
		else {
			//update the label with an error message
			bitcoinPriceLabel.text = "Bitcoin Value Unavailable"
		}
    }//updateTicker(json : JSON)
	
}//ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate

