//
//  ViewController.swift
//  TestPhoneVerification
//
//  Created by Odiljon Ergashev on 2023/02/16.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var customWebView: CustomWKWebView!
    
    
    let url = "http://52.79.159.186:8080/seyfert/phone/main?type=REG"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customWebView.loadUrl(url)
    }


}

