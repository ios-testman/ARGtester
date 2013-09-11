//
//  WebViewController.h
//  ARGtester
//
//  Created by okumura on 2013/09/10.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *wv;
    UIActivityIndicatorView* indicator;
}

@property (nonatomic, retain) UIWebView *wv;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;



- (IBAction)onClickCloseBtn:(id)sender;




@end
