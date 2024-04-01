//
//  ViewController.swift
//  TesejournerX
//
//  Created by Andrii Momot on 20.03.2024.
//

import UIKit
import SwiftUI

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showSwitUIView()
    }
}

private extension ViewController {
    func showSwitUIView() {
        let swiftUIViewController = UIHostingController(rootView: RootContentView())
        
        addChild(swiftUIViewController)
        view.addSubview(swiftUIViewController.view)
        swiftUIViewController.didMove(toParent: self)
        
        swiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            swiftUIViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            swiftUIViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            swiftUIViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            swiftUIViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
