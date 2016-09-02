//
//  WebVC
//  SamsaoTest
//
//  Created by Robin Somlette on 02-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    
    @IBOutlet weak var container: UIView!
    
    var url: String!
    var repoTitle: String!
    var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.container.addSubview(webView)
        
        self.title = repoTitle
        
        
        if #available(iOS 9.0, *) {
            webView.allowsLinkPreview = true
        } else {
            // Fallback on earlier versions
        }
        webView.allowsBackForwardNavigationGestures = true
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        webView.frame = CGRectMake(0, 0, container.bounds.width, container.bounds.height)
        
        if let url = NSURL(string: self.url) {
            print("Loading Request")
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
            webView.estimatedProgress
        } else {
            print("Nothing to Load")
        }

    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        self.webView.frame = CGRectMake(0, 0, size.width, size.height)

    }
    
}

extension WebVC: WKNavigationDelegate {
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
