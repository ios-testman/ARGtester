//
//  SimpleImageViewController.h
//  ARGtester
//
//  Created by okumura on 2013/09/09.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleImageViewController : UIViewController
{
    int IMAGE_MAX;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onClickCloseBtn:(id)sender;

@end
