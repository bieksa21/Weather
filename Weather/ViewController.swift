//
//  ViewController.swift
//  Weather
//
//  Created by joey frenette on 2016-10-10.
//  Copyright © 2016 joey frenette. All rights reserved.
//

import UIKit

@IBDesignable
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    var city: String = "Vancouver"
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Allows current view controller to use methods from UITextFieldDelegate
        textfield.delegate = self
    }
    
    @IBAction func Submit(_ sender: UIButton) {
        city = textfield.text!
        self.view.endEditing(true)
        if city.contains(" ") {
            city = self.city.replacingOccurrences(of: " ", with: "-")
        }
        getWebData()
    }

    func getWebData() {
        if let url = URL(string: "http://www.weather-forecast.com/locations/\(city)/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                
                if error != nil {
                    print(error)
                    self.outputLabel.text = "Please re-enter a proper city name"
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        //print(dataString)
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            var message = ""
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    let tempArray = newContentArray[0].components(separatedBy: "max ")
                                    let degArray = tempArray[1].components(separatedBy: " on")
                                    /*if self.message == "" {
                                        self.message = "Couldn't find the weather here, try again."
                                    }*/
                                    DispatchQueue.main.sync(execute:
                                    {
                                        //Update UI here otherwise it will change too slowly!
                                        self.outputLabel.text = message
                                        self.temperatureLabel.text = degArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    })
                                }
                            }
                            
                            if message == "" {
                                DispatchQueue.main.sync(execute:
                                {
                                    self.outputLabel.text = "Could not find weather information. Please enter a valid city."
                                    self.temperatureLabel.text = ""
                                })
                            }
                        }
                    }
                }
            }
            task.resume()
        } else {
            outputLabel.text = "Please re-enter a proper city name."
            temperatureLabel.text = ""
        }
    }
    
    

    
    //keyboard return handlers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }

}
