//
//  Tool.swift
//  RealRiderFuryChase
//
//  Created by jin fu on 2024/12/24.
//

import UIKit

var puzzels: [RealRiderPuzzelFile] = [
    RealRiderPuzzelFile(level: 1, image: ["A1", "A2", "A3", "A4"]),
    RealRiderPuzzelFile(level: 2, image: ["B1", "B2", "B3", "B4"]),
    RealRiderPuzzelFile(level: 3, image: ["C1", "C2", "C3", "C4"]),
    RealRiderPuzzelFile(level: 4, image: ["D1", "D2", "D3", "D4"]),
    RealRiderPuzzelFile(level: 5, image: ["E1", "E2", "E3", "E4"]),
    RealRiderPuzzelFile(level: 6, image: ["F1", "F2", "F3", "F4"]),
    RealRiderPuzzelFile(level: 7, image: ["G1", "G2", "G3"]),
    RealRiderPuzzelFile(level: 8, image: ["H1", "H2", "H3"]),
]

func showAlert(on viewController: UIViewController, title: String, message: String) {
    // Create the alert controller
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    // Add an OK action to the alert
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        viewController.navigationController?.popViewController(animated: true)
    }
    alert.addAction(okAction)
    
    viewController.present(alert, animated: true, completion: nil)
}
