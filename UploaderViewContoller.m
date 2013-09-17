//
//  UploaderViewContoller.m
//  ARGtester
//
//  Created by okumura on 2013/09/12.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "UploaderViewContoller.h"

@implementation UploaderViewContoller

@synthesize wv;
@synthesize indicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //登録画像を１枚かメラロールにコピー
    [self sevePhotosAlbum];
    
    // 画面作成
    
    /*
     NSURL *urlsafari = [NSURL URLWithString:@"http://graphuploder.herokuapp.com"];
     [[UIApplication sharedApplication] openURL:urlsafari];
     */
    
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
}

- (void)sevePhotosAlbum {

   
    //カメラロールにもこれを使えば保存可能？
    NSLog(@"save file name = %@",fullPath);
    NSData* img_data = [NSData dataWithContentsOfFile:fullPath];
    UIImage *image = [[UIImage alloc] initWithData:img_data];
   
        
    [self savePicture:image];
    NSLog(@"Saved %@",fullPath);
}

- (IBAction)onClickCloseBtn:(id)sender {
    //画面終了
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)savePicture:(UIImage*)image
{
    SEL sel = @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(image, self, sel, nil);
}

- (void)savingImageIsFinished:(UIImage*)_image didFinishSavingWithError:(NSError*)_error contextInfo:(void*)_contextInfo
{
   /*
    NSString *message = @"画像を保存しました";
    if (_error) message = @"画像の保存に失敗しました";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                    message: message
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    */
    if (_error) {
        NSLog(@"Error save graph %@",fullPath);
    }
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

-(void) removeGraphfromPhotoAlubum
{
    /*
    NSString* PhAl_path = @"/var/mobile/Media/DCIM/100APPLE/";
   NSFileManager *fileManager = [NSFileManager defaultManager];
   /for (int num = 0; num < IMAGE_MAX; num++) {
        NSString* fileName = [files objectAtIndex:num];
   
        NSString* PhAl_fullPath = [PhAl_path stringByAppendingPathComponent:fileName];
    
        // ファイルを移動
        NSError *error;
        BOOL result = [fileManager removeItemAtPath:PhAl_fullPath error:&error];
        if (result) {
            NSLog(@"ファイルを削除に成功：%@", PhAl_fullPath);
        } else {
            NSLog(@"ファイルの削除に失敗：%@", error.description);
        }
    
    }
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
