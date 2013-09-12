//
//  UploaderViewContoller.m
//  ARGtester
//
//  Created by okumura on 2013/09/12.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "UploaderViewContoller.h"

@implementation UploaderViewContoller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* paths = [self myDocumentsPath];
    
    // データ保存用のディレクトリを作成する
    publicDocumentsDir = paths;
    if ([self makeDirForAppContents]) {
        // ディレクトリに対して「do not backup」属性をセット
        NSURL* dirUrl = [NSURL fileURLWithPath:paths];
        [self addSkipBackupAttributeToItemAtURL:dirUrl];
        publicDocumentsDir = [dirUrl host];
        
    }
    
    NSError* docerror;
    files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:publicDocumentsDir error:&docerror];
    if (files == nil)
    {
        NSLog(@"Error reading contents of documents directory: %@", [docerror localizedDescription]);
    }
    
    IMAGE_MAX = [files count];
}

- (IBAction)onClickUpload:(id)sender {

    NSLog(@"IMAGE_MAX = %d",IMAGE_MAX);
    for (int num = 0; num < IMAGE_MAX; num++) {
        // ファイル名取得
        NSString* fileName = [files objectAtIndex:num];
        fullPath = [publicDocumentsDir stringByAppendingPathComponent:fileName];
    
        //カメラロールにもこれを使えば保存可能？
     
      
        NSData* img_data = [NSData dataWithContentsOfFile:fullPath];
        UIImage *image = [[UIImage alloc] initWithData:img_data];
   
        
        [self savePicture:image];
        NSLog(@"Saved %@",fullPath);
    }
    
    /*
    NSURL *urlsafari = [NSURL URLWithString:@"http://graphuploder.herokuapp.com"];
    [[UIApplication sharedApplication] openURL:urlsafari];
     */
}

- (IBAction)onClickCloseBtn:(id)sender {
    
    //画像削除
    [self removeGraphfromPhotoAlubum];
    
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

@end
