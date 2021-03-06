//
//  ViewController.swift
//  Weather App
//
//  Created by Mickey Goga on 1/14/18.
//  Copyright © 2018 Magy Elias. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    //Constants
    let weather_URL = "http://api.openweathermap.org/data/2.5/weather"
    let app_ID = "98d88aa52d6b8445fe06434fc4ec759a"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
//    var textPassedOver : String?
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var changeTempSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTempSwitch.isHidden = true
        //Set up the Location manager her:
        locationManager.delegate = self             //WeatherViewController as a Delegate of the locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Networking
    /***********************************************************************************************************/
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method:.get, parameters: parameters).responseJSON {  //get method is http reuest method and used to retrieve data
            response in         //Closure
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
//                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parcing
    /***********************************************************************************************************/
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON) {
        
        if let tempResult  = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    /***********************************************************************************************************/
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        temperatureLabel.text = "\(weatherDataModel.temperature)°"   //String(weatherDataModel.temperature)
        cityLabel.text = weatherDataModel.city
        weatherImageView.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: - Location Manager Delegate Methods
    /***********************************************************************************************************/
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Tells the delegate that new location data is available
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {    //not invalid location
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("longitude= \(location.coordinate.longitude), latitude= \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : app_ID]
            getWeatherData(url: weather_URL, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Tells the delegate that the location manager was unable to retrieve a location value
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    /***********************************************************************************************************/
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
//        print(city)
        let params : [String : String] = ["q" : city, "appid" : app_ID]
        getWeatherData(url: weather_URL, parameters: params)
    }
    
    //Write the PrepareForsegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
//    @IBAction func changeTempTypeSwitch(_ sender: UISwitch) {
//        if changeTempSwitch.isOn {
//
//        }
//        //temperatureLabel.text = String(Double(temperatureLabel.text!)! + 273.15)
//    }
}

