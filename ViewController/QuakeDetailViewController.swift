//
//  QuakeDetailViewController.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/13/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation
import WebKit

/* Use to display the detail earth quake data
 */
class QuakeDetailViewController: DevoeViewController {
    
    //
    //MARK: - IBOutlet section
    //
       
    @IBOutlet weak var webView: WKWebView!
    
    //
    //MARK: - Private member section
    //
    private var detailURL: URL? = nil // encapsulate the member, OOD
    
    
    //
    //MARK: - View Controller life cycel
    //
    override func viewDidLoad() {
        
        if let detailURL = self.detailURL {
            let _ : WKNavigation? = self.webView.load(URLRequest(url: detailURL))
            self.webView.allowsBackForwardNavigationGestures = true
        } else {
            print( "No URL provided" )
        }
        
    }
    
    // Setup the URL before the window instantiates
    func loadWeb( _ url: String ) {
        self.detailURL = URL( string: url )
    }
}
