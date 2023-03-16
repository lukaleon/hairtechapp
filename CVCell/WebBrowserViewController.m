//
//  WebBrowserViewController.m
//  hairtech
//
//  Created by Alexander Prent on 13.03.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController ()

@end

@implementation WebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"User guide";
    // Initialize the WKWebView
   // self.webViewKit = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webViewKit.navigationDelegate = self;
    
    // Add the WKWebView to the view hierarchy
    [self.view addSubview:self.webViewKit];
    
    // Load a web page
    NSURL *url = [NSURL URLWithString:@"https://private-voice-302.notion.site/User-Guide-for-HairTechApp-0250c894ee7346daa1a0a9ad25e05620"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webViewKit loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // Called when the web view begins to load a page
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // Called when the web view finishes loading a page
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // Called when the web view fails to load a page
}

@end

