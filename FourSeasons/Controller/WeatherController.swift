//
//  WeatherController.swift
//  FourSeasons
//
//  Created by Kim Page on 2/9/19.
//  Copyright © 2019 Kim Page. All rights reserved.
//


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    
    let locationManager = CLLocationManager()
    let weatherData = WeatherData()
    
    
    
    
    
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "nature")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    let switchButton: UIButton = {
        
        let image = UIImage(named: "switch")
        
        let button = UIButton(type: .custom)
        
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    @objc func switchButtonTapped() {
        
        performSegue(withIdentifier: "changeCityName", sender: self)
        
    }
    
    
    let temperatureLabel: UILabel  = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    
    
    let weatherIcon: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    
    let cityLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
        
    }()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setupView()
        
        
    }
    
    
    
    func setupView() {
        
        view.addSubview(backgroundImageView)
        backgroundImageView.pinToEdges(view: self.view)
        
        
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, weatherIcon, cityLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        
        stackView.anchor(top: view.safeTopAnchor, left: view.safeLeftAnchor, right: view.safeRightAnchor, bottom: view.safeBottomAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, paddingBottom: 20)
        
        
        
        view.addSubview(switchButton)
        
        switchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        switchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        switchButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Networking
   
    
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    //MARK: - JSON Parsing
    
    
    
    
    func updateWeatherData(json : JSON) {
        
        let tempResult = json["main"]["temp"].doubleValue
        
        weatherData.temperature = Int(tempResult - 273.15)
        
        weatherData.city = json["name"].stringValue
        
        weatherData.condition = json["weather"][0]["id"].intValue
        
        weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
        
        
        updateUIWithWeatherData()
    }
    
    
    
    
    
    
    //MARK: - UI Update
    
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherData.city
        temperatureLabel.text = "\(weatherData.temperature)°"
        weatherIcon.image = UIImage(named: weatherData.weatherIconName)
        
    }
    
    
    
    
    //MARK: - Location Manager Delegate

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            self.locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate 
  
    
    
    
    
    func userEnteredANewCityName(city: String) {
        
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! CityController
            
            
            destinationVC.delegate = self
            
        }
        
    }
    
    

    
}











