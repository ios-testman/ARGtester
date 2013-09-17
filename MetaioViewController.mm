//
//  MetaioViewController.m
//  ARGtester
//
//  Created by okumura on 2013/09/06.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "MetaioViewController.h"
#import "EAGLView.h"


@implementation MetaioViewController

// gesture masks to specify which gesture(s) is enabled
//int GESTURE_DRAG = 1<<0;
//int GESTURE_ROTATE = 2<<0;
//int GESTURE_PINCH = 4<<0;
//int GESTURE_ALL = 0xFF;

//画面表示
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // make the subview transparent
    _subview.backgroundColor = [UIColor clearColor];
    
    m_gestures = 0xFF; //enables all gestures
    m_gestureHandler = [[GestureHandlerIOS alloc] initWithSDK:m_metaioSDK withView:glView withGestures:m_gestures];
    
    m_imageTaken = false;
    
    // load our tracking configuration
    bool success = m_metaioSDK->setTrackingConfiguration("ORIENTATION_FLOOR");
    NSLog(@"ORIENTATION tracking has been loaded: %d", (int)success);
    
    
    // load content　データ読み込み
    // load chair テストで椅子のデータを扱う。でも本番プリンタなのでファイル名はプリンタ統一
    NSString *PrinterPath = [self findAssetFromName:@"stuhl" ofType:@"obj"]; //ファイルパス確認
   // NSString* PrinterPath = [[NSBundle mainBundle] pathForResource:@"stuhl" ofType:@"obj" inDirectory:@"tutorialContent_crossplatform/Tutorial7/Assets7"];
    if (PrinterPath)
    {
        //モデル生成
        m_chair = m_metaioSDK->createGeometry([PrinterPath UTF8String]);
        if (m_chair)
        {
            m_chair->setScale(metaio::Vector3d(50.0, 50.0, 50.0));
            //rotate the chair to be upright
            m_chair->setRotation(metaio::Rotation(M_PI_2, 0.0, 0.0));
            m_chair->setTranslation(metaio::Vector3d(0.0, 0.0, 0.0));
            [m_gestureHandler addObject:m_chair andGroup:2];
        }
        else
        {
            NSLog(@"Error loading the Printer: %@", PrinterPath);
        }
    }
    [self setVisiblePrinter:false];//オブジェクトを非表示に
    
    
    // set button images to each state　アイコン画像を非表示に
    NSString* Button_OFF = @"Assets/button_chair_unselected";
    NSString* Button_ON = @"Assets/button_chair_selected";
    for (UIView* subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*) subView;
            NSString* title = button.currentTitle;
            NSString* Chk_str = @"貼"; //ボタンのtitleならこれしかあるめぇ？
            if ([title isEqual:Chk_str])
            {
                [button setSelected:false];
                [button setImage:[UIImage imageWithContentsOfFile:[self findAssetFromName:Button_OFF ofType:@"png"]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageWithContentsOfFile:[self findAssetFromName:Button_ON ofType:@"png"]] forState:UIControlStateSelected];
              
            }
        }
    }
	
}


//使用ファイル名探索
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
 

#pragma mark - Rotation handling
//自動回転？
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)InterfaceOrientation
{
    // allow rotation in all directions
    return YES;
}

//フレーム描画
- (void)drawFrame
{
    [super drawFrame];
    
    // laod the dummy tracking config file once a camera image has been taken and move the geometries to a certain location on the screen
    if (m_imageTaken)
    {
        bool result = m_metaioSDK->setTrackingConfiguration("DUMMY");
        NSLog(@"Tracking data dummy loaded: %d", (int)result);
        
		// set the previously loaded pose
		m_metaioSDK->setCosOffset(1, m_pose);
        
        m_imageTaken = false;
    }
}

#pragma mark - @protocol MobileDelegate
//メタイオマン用のアクション　今回使わないな
- (void) onAnimationEnd: (metaio::IGeometry*) geometry  andName:(NSString*) animationName
{
        
}

#pragma mark - Handling Touches
//画面タッチ時の動作決定
//画面タッチ開始
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // record the initial states of the geometries with the gesture handler
    [m_gestureHandler touchesBegan:touches withEvent:event withView:glView];
    
    // Here's how to pick a geometry
	UITouch *touch = [touches anyObject];
	CGPoint loc = [touch locationInView:glView];
	
    // get the scale factor (will be 2 for retina screens)
    float scale = glView.contentScaleFactor;
    
	// ask sdk if the user picked an object
	// the 'true' flag tells sdk to actually use the vertices for a hit-test, instead of just the bounding box
    metaio::IGeometry* model = m_metaioSDK->getGeometryFromScreenCoordinates(loc.x * scale, loc.y * scale, false);
	
    if (model == 0x00)
	{
		NSLog(@"model don't read");
	}
}
//タッチ中
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // handles the drag touch
    [m_gestureHandler touchesMoved:touches withEvent:event withView:glView];
}
//指離し
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_gestureHandler touchesEnded:touches withEvent:event withView:glView];
}



// handles the reactions from touching the geometry buttons. it not only show/hide the geometries, it also resets the location and the scale

//最初画面に戻る
- (IBAction)onClickCloseBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//オブジェクト表示（3dオブジェクト　直方体の立方体になる予定)
- (IBAction)onPrinterButtonClick:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if ([button isSelected])
    {
        button.selected = false;
        [self setVisiblePrinter:false];
    }
    else
    {
        button.selected = true;
        [self setVisiblePrinter:true];
        
        CGRect screen = self.view.bounds;
        CGFloat width = screen.size.width * [UIScreen mainScreen].scale;
        CGFloat height = screen.size.height * [UIScreen mainScreen].scale;
        metaio::Vector3d translation = m_metaioSDK->get3DPositionFromScreenCoordinates(1, metaio::Vector2d(width/2, height/2));
        
        
        m_chair->setTranslation(translation);
        m_chair->setScale(metaio::Vector3d(50.0, 50.0, 50.0));
    }}


// take picture button pressed. カメラ画像撮影
- (IBAction)onTakePicture:(id)sender
{
    NSString* dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@/targetImage.jpg", dir];
    m_metaioSDK->requestCameraImage([filePath UTF8String]);
    //    m_metaioSDK->requestCameraImage();
}

// save screenshot button pressed　画面保存
- (IBAction)onSaveScreen:(id)sender
{
   // origin
   // NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString* publicDocumentsDir = [paths objectAtIndex:0];
    
    NSString* paths = [self myDocumentsPath];
    
    // データ保存用のディレクトリを作成する
    NSString* publicDocumentsDir = paths;
    if ([self makeDirForAppContents]) {
        // ディレクトリに対して「do not backup」属性をセット
        NSURL* dirUrl = [NSURL fileURLWithPath:paths];
        [self addSkipBackupAttributeToItemAtURL:dirUrl];
        publicDocumentsDir = [dirUrl host];
        
    }
    
        
    NSError* docerror;
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:publicDocumentsDir error:&docerror];
    if (files == nil)
    {
        NSLog(@"Error reading contents of documents directory: %@", [docerror localizedDescription]);
    }
    
    
    NSString* timeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString* fileName = [NSString stringWithFormat:@"%@.jpg", timeStamp];
    NSString* fullPath = [publicDocumentsDir stringByAppendingPathComponent:fileName];
    
    
    m_metaioSDK->requestScreenshot([fullPath UTF8String], glView->defaultFramebuffer, glView->colorRenderbuffer);
    //    m_metaioSDK->requestScreenshot(glView->defaultFramebuffer, glView->colorRenderbuffer);
    NSLog(@"framebuffer = %d",glView->defaultFramebuffer);
    
    // generate an alert to notify the user of screenshot saving
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"報告"
                                                      message:@"画面画像をアプリ内フォルダに保存しました"
                                                     delegate:nil
                                            cancelButtonTitle:@"確認終了"
                                            otherButtonTitles:nil];
    [message show];
    
   }

// reset the app -- reactivate the camera, hide the geometries and change the button state (selected) from true to false
// 表示中のオブジェクトを排除し、やり直す
- (IBAction)onClearScreen:(id)sender
{
    // reactivate the camera
    m_metaioSDK->startCamera(0);
    
    // reload the orientation tracking config file
    bool success = m_metaioSDK->setTrackingConfiguration("ORIENTATION_FLOOR");
    NSLog(@"ORIENTATION tracking has been loaded: %d", (int)success);
    
    [self setVisiblePrinter:false];
       
    // reset the button images to "unselected"
    for (UIView* subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*) subView;
            NSString* title = button.currentTitle;
            if ([title isEqual:@"Printer"])
            {
                button.selected = false;
            }
        }
    }
}

// hide/show the geometries
//ボタン画像の　点けたり　消したり
// 使用中かどうかの判断
- (void)setVisiblePrinter:(bool)visible
{
    if (m_chair != NULL)
    {
        m_chair->setVisible(visible);
    }
}


// set the camera image as the tracking target
//カメラ撮影 撮影後は画面表示のまま
- (void) onCameraImageSaved: (NSString*) filepath
{
    if (filepath.length > 0)
    {
        m_metaioSDK->setImage([filepath UTF8String]);
    }
    m_imageTaken = true;
	
	//remember the current pose
	m_pose = m_metaioSDK->getTrackingValues(1);
    
}

//カメラ用のフレーム準備
- (void) onNewCameraFrame:(metaio::ImageStruct *)cameraFrame
{
    UIImage* image = m_metaioSDK->ImageStruct2UIImage(cameraFrame, true);
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

//ログ表示（保存確認)
-(void) onScreenshotSaved:(NSString*) filepath
{
	NSLog(@"Image saved: %@", filepath);
}



- (void) onScreenshotImageIOS:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}



// ディレクトリ作成(App以下Document内にiCloud対応外のディレクトリ作成
- (BOOL)makeDirForAppContents
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *baseDir = [self myDocumentsPath];
    
    BOOL exists = [fileManager fileExistsAtPath:baseDir];
    if (!exists) {
        NSError *error;
        BOOL created = [fileManager createDirectoryAtPath:baseDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSLog(@"ERR Directry can't create");
            return NO;
        }
    } else {
        return NO; // 作成済みの場合はNO
    }
    return YES;
}

- (NSString *)myDocumentsPath
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"savePic"]; //追加するディレクトリ名を指定
    return path;
}

// 指定箇所をiCloudのバックアップ対象外に
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                    
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        
    }
    
    return success;
}


- (void)viewDidUnload {
    [self setSubview:nil];
    [super viewDidUnload];
}


@end
