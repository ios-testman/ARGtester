//
//  WebViewController.h
//  ARGtester
//
//  Created by okumura on 2013/09/10.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *indicator;
    Photo *photo;
}

@property (nonatomic, retain) Photo *photo;

- (IBAction)onClickCloseBtn:(id)sender;
- (void) openUrl : (Photo *) _photo;



@end
