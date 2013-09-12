//
//  UploaderViewContoller.h
//  ARGtester
//
//  Created by okumura on 2013/09/12.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploaderViewContoller : UIViewController
{
    NSArray* files;
    NSString* publicDocumentsDir;
    int IMAGE_MAX;
    NSString* fullPath;

}
- (IBAction)onClickUpload:(id)sender;
- (IBAction)onClickCloseBtn:(id)sender;

@end
