//
//  WebBrowserViewController.h
//  hairtech
//
//  Created by Alexander Prent on 13.03.2023.
//  Copyright © 2023 Admin. All rights reserved.
//
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface WebBrowserViewController : UIViewController<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webViewKit;

@end

NS_ASSUME_NONNULL_END
