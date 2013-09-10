//
//  WebViewController.m
//  ARGtester
//
//  Created by okumura on 2013/09/10.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController


@synthesize photo;
- (void) openUrl:(NSURL *)urString
{
    [indicator startAnimating];
    [webView loadRequest:[NSURLRequest requestWithURL:urString]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webView setDelegate:self];
    [indicator setHidesWhenStopped:YES];
    [[UIApplication sharedApplication] openURL:[self url]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
}

- (IBAction)onClickCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSURL *) url {
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"http://graphuploder.herokuapp.com"]];
}

@end
