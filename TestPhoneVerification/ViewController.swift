//
//  ViewController.swift
//  TestPhoneVerification
//
//  Created by Odiljon Ergashev on 2023/02/16.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    @objc(userContentController:didReceiveScriptMessage:) func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("*********")
        print(message)
        print("*********")
        
        if message.name == "SeyfertCall" {
            print(message.body)
        }
        
    }
    
	
	var webViews = [WKWebView]()
	var webView: WKWebView!
	
    let url = "http://52.79.159.186:8080/seyfert/phone/main?type=REG"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
            contentController.add(self, name: "SeyfertCall")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        
		let screenSize: CGRect = UIScreen.main.bounds
		webView = createWebView(frame: screenSize, configuration: config)
		
		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.scrollView.bounces = true;
		webView.scrollView.showsHorizontalScrollIndicator = false
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.scrollView.scrollsToTop = true;
		
		//Message Handler
		webView.configuration.userContentController = WKUserContentController()
        
        
		
		//Default = fasle
		//true -> Render from memory then show
		//if true, view is Black while rendering
		webView.configuration.suppressesIncrementalRendering = false
		
		//Default = dynamic
		//Text Select Accuracy
		webView.configuration.selectionGranularity = WKSelectionGranularity.dynamic
		
		//Default = false -> HTML5 video play
		//true -> native full-screen play
		webView.configuration.allowsInlineMediaPlayback = false
		
		if #available(iOS 9, *){
			
			//Airplay allowance
			webView.configuration.allowsAirPlayForMediaPlayback = false
			
			//Default = true
			//Whether HTML5 video can play in PIP
			webView.configuration.allowsPictureInPictureMediaPlayback = true
			
			//Let use LocalStorage
			webView.configuration.websiteDataStore = WKWebsiteDataStore.default()
			
			if #available(iOS 10.0, *) {
				
				//.all = all media playback auto starts
				//.video = video auto starts
				//.auido = audio auto starts
				webView.configuration.mediaTypesRequiringUserActionForPlayback = .all
				
			}
			
		}
		
		//preference setting
		webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
		webView.configuration.preferences.minimumFontSize = 0
		
		if #available(iOS 14, *) {
			
			webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
			
		} else {
			
			webView.configuration.preferences.javaScriptEnabled = true
			
		}
		
		webView.load(URLRequest(url: URL(string: url)!))
        
    }
	
	override func loadView() {
		
		let webConfiguration = WKWebViewConfiguration()
		webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView.uiDelegate = self
		view = webView
		
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		
		print(navigationAction.request.url?.absoluteString ?? "")

		let url = navigationAction.request.url!
		
		if ["https://itunes.apple.com", "niceipin2"].contains(url.scheme) {
			
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
			
			decisionHandler(.cancel)
			
			return
			
		}

		decisionHandler(.allow)
		
	}
	
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		
		guard let frame = self.webViews.last?.frame else {
			return nil
		}

		return createWebView(frame: frame, configuration: configuration)
		
	}

	
	func webViewDidClose(_ webView: WKWebView) {
		
		destroyCurrentWebView()
		
	}
	
	func createWebView(frame: CGRect, configuration: WKWebViewConfiguration) -> WKWebView {
		
		let webView = WKWebView(frame: frame, configuration: configuration)

		webView.uiDelegate = self
		webView.navigationDelegate = self

		self.view.addSubview(webView)

		self.webViews.append(webView)

		return webView
	
	}
	
	func destroyCurrentWebView() {
		
		self.webViews.popLast()?.removeFromSuperview()
		
	}
    
    ///
    
    
    

    

	
}

