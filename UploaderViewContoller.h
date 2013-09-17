//
//  UploaderViewContoller.h
//  ARGtester
//
//  Created by okumura on 2013/09/12.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleImageViewController.h"

@interface UploaderViewContoller : UIViewController <UIWebViewDelegate>
{
    @public
    NSString* fullPath;
    
    @private
    UIWebView *wv;
    UIActivityIndicatorView* indicator;

}

- (IBAction)onClickCloseBtn:(id)sender;

@property (nonatomic, retain) UIWebView *wv;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@end
