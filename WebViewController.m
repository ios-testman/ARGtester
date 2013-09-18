//
//  WebViewController.m
//  ARGtester
//
//  Created by okumura on 2013/09/10.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController


- (IBAction)onClickCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@synthesize wv;
@synthesize indicator;

-(void)viewDidLoad {
    

    NSURL *urlsafari = [NSURL URLWithString:@"http://graphuploader.herokuapp.com"];
    [[UIApplication sharedApplication] openURL:urlsafari];

    /*
    
    [self.view setBackgroundColor:[UIColor colorWithRed:100/256.0 green:100/256.0 blue:100/256.0 alpha:1.0f]];
    
    //webview1を作成
    self.wv = [[UIWebView alloc] init];
    self.wv.delegate = self;
    self.wv.frame = CGRectMake(0, 33, 320, 480);
    self.wv.backgroundColor = [UIColor blackColor];
    self.wv.alpha = 0.9;
    self.wv.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:@"http://graphuploader.herokuapp.com"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.wv loadRequest:req];
    [self.view addSubview:self.wv];
    
    //インジケーターを用意する
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.frame = CGRectMake((320/2)-20, (510/2)-60, 40, 40);
    [self.view addSubview:self.indicator];
     */
 }


//WEBの読み込みを開始したら
- (void)webViewDidStartLoad:(UIWebView*)webView {
    //インジケーターの表示
    [indicator startAnimating];
}

//WEBの読み込み成功したら
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    //インジケーターの非表示
    [indicator stopAnimating];
}

//WEBの読み込みに失敗したら
- (void)webView:(UIWebView*)webView
didFailLoadWithError:(NSError*)error {
    //インジケーターの非表示
    [indicator stopAnimating];
}

- (void)dealloc {
   // [wv release];
   // [indicator release];
   // [super dealloc];
}

@end
