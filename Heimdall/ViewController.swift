//
//  ViewController.swift
//  Heimdall
//
//  Created by Edho Prasetyo on 16/09/25.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "This is your final destination. Please use the widget to get the movie schedule 😊."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            // Center horizontally and vertically
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
//        ])
        
        let button = UIButton(type: .system)
        button.setTitle("Update Widget", for: .normal)
        button.addTarget(self, action: #selector(updateWidget), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        view.addSubview(button)
    }
    
    @objc func updateWidget() {
        // Save something new to shared data
        let message = "Updated at \(Date().formatted())"
        SharedDataStore.saveMessage(message)

        // Tell widget to reload
        WidgetCenter.shared.reloadAllTimelines()
    }
}
