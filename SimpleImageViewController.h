//
//  SimpleImageViewController.h
//  ARGtester
//
//  Created by okumura on 2013/09/09.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleImageViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    int IMAGE_MAX;
    NSArray* files;
    NSString* publicDocumentsDir;
    NSString* cellImageName ;
    NSIndexPath * checkNumber;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onClickCloseBtn:(id)sender;
- (IBAction)onClickDeleteBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *uploadGraph;
@property (weak, nonatomic) IBOutlet UIButton *deleteGraph;

@end
