//
//  CityController.swift
//  FourSeasons
//
//  Created by Kim Page on 2/9/19.
//  Copyright © 2019 Kim Page. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class CityController: UIViewController {
    
    var delegate: ChangeCityDelegate?
    
    
    let backgroundImageView: UIImageView = {
        
        let view = UIImageView()
        view.image = UIImage(named: "city")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    let backButton: UIButton = {
        
        let image = UIImage(named: "left")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
        
    }()
    
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    let changeCityTextField: UITextField = {
        
        let tf = UITextField()
        
        tf.placeholder = "Enter City Name"
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        
        
        return tf
        
    }()
    
    
    
    let getWeatherButton: UIButton  = {
        
        let button = UIButton(type: .system)
        button.setTitle("get weather", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.addTarget(self, action: #selector(getWeatherPressed), for: .touchUpInside)
        
        return button
        
    }()
    
    
    @objc func getWeatherPressed() {
        let cityName = changeCityTextField.text!
        
        delegate?.userEnteredANewCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        
    }
    
    
    
    func setupView() {
        
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.pinToEdges(view: self.view)
        
        
        
        
        
        
        view.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        let stackView = UIStackView(arrangedSubviews: [changeCityTextField, getWeatherButton])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        
        
        
        
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        
        
    }
    
  
    
}
