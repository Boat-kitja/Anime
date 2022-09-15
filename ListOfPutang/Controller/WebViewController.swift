//
//  WebViewController.swift
//  ListOfPutang
//
//  Created by Kitja  on 1/9/2565 BE.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    @IBOutlet weak var linkLabel: UIButton!
    @IBOutlet weak var dissMiss: UIBarButtonItem!
    @IBOutlet weak var share: UIBarButtonItem!
    
    var url:String?
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
        webView.allowsBackForwardNavigationGestures = true
        webView.backForwardList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:url ?? "")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        self.navigationItem.title = url
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let activityAC = UIActivityViewController(activityItems: [url ?? "Can not find url"], applicationActivities: nil)
        activityAC.popoverPresentationController?.sourceView = self.view
        self.present(activityAC, animated: true)
    }
    
    @IBAction func dissMiss(_ sender: UIButton) { 
        _ = navigationController?.popViewController(animated: true)
    }
}



