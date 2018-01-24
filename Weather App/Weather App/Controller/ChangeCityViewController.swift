//
//  ChangeCityViewController.swift
//  Weather App
//
//  Created by Mickey Goga on 1/15/18.
//  Copyright © 2018 Magy Elias. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city : String)
}


class ChangeCityViewController: UIViewController {

    @IBOutlet weak var changeCityTextField: UITextField!
    
    //delegate property
    var delegate : ChangeCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "goToChangeCityScreen" {
//            let distantionVC = segue.destination as! WeatherViewController
//            distantionVC.textPassedOver = changeCityTextField.text!
//        }
//    }
    
    @IBAction func getWeatherPressed(_ sender: UIButton) {
        //1. Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
//        print(cityName)
        //2. If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)   //? -> optional chaining (if delegate is not nil)
        
        //3. dismiss the change City View Controller to go back to the Weather View Controller
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
