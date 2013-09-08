//
//  MetaioViewController.h
//  ARGtester
//
//  Created by okumura on 2013/09/06.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "MetaioSDKViewController.h"
#import <metaioSDK/GestureHandlerIOS.h>


@interface MetaioViewController : MetaioSDKViewController
{
    // pointers to geometries
    metaio::IGeometry* m_chair;
    
    // GestureHandler handles the dragging/pinch/rotation touches
    GestureHandlerIOS* m_gestureHandler;
    //gesture mask to specify the gestures that are enabled
    int m_gestures;
    //indicate if a camera image has been requested from the user
    bool m_imageTaken;
	// remember the TrackingValues
	metaio::TrackingValues m_pose;
}

/* 
 system button
 */
// close
- (IBAction)onClickCloseBtn:(id)sender;
// take picture
- (IBAction)onTakePicture:(id)sender;
// save screen
- (IBAction)onSaveScreen:(id)sender;
// reset
- (IBAction)onClearScreen:(id)sender;


//geometry button callback to show/hide the geometry and reset the location and scale of the geometry
- (IBAction)onPrinterButtonClick:(id)sender;


@property (unsafe_unretained, nonatomic) IBOutlet UIView *subview;

//show/hide the geometries
- (void)setVisiblePrinter:(bool)visible;

@end
