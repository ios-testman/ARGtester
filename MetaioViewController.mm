//
//  MetaioViewController.m
//  ARGtester
//
//  Created by okumura on 2013/09/06.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "MetaioViewController.h"

@implementation MetaioViewController


- (IBAction)onClickCloseBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *trackingConfigFile = [self findAssetFromName:@"TrackingData_Marker" ofType:@"xml"];
    bool trackingConfigResult = m_metaioSDK->setTrackingConfiguration([trackingConfigFile UTF8String]);
    if (!trackingConfigResult) {
        [NSException raise:@"tracking config error" format:@"can't load tracking config"];
    }
    
    NSString *modelFile = [self findAssetFromName:@"stuhl" ofType:@"obj"];
    metaio::IGeometry *model = m_metaioSDK->createGeometry([modelFile UTF8String]);
    if (!model) {
        [NSException raise:@"model create error" format:@"can't create model"];
    }
}
- (NSString *)findAssetFromName:(NSString *)name ofType:(NSString *)ofType
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:name
                                                         ofType:ofType
                                                    inDirectory:@"Assets"];
    if (!fileName) {
        [NSException raise:@"find asset error" format:@"can't find %@.%@", name, ofType];
    }
    return fileName;
}

@end
