//
//  SimpleImageViewController.m
//  ARGtester
//
//  Created by okumura on 2013/09/09.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "SimpleImageViewController.h"

@implementation SimpleImageViewController

- (IBAction)onClickCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IMAGE_MAX = 1;
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

    
    // bgView の回転 (時計回りに90°)
    // -90°にしないのにはわけがある！
    CGRect originalFrame = self.bgView.frame;
    self.bgView.center = CGPointMake(320/2,460/2);
    self.bgView.transform = CGAffineTransformMakeRotation(M_PI * 90 / 180.0f);
    self.bgView.frame = originalFrame;
    
    // ページ単位でスクロールをかっちり止めるにはYES
    self.tableView.pagingEnabled = YES;
    
    // UITableViewも親につられて時計回りに90°回転しているので、一番下のrowが左端になる。
    // よって一番下のrowを最初に表示させる。
    int FirstRow = 0;
    if (IMAGE_MAX > 1) { //IMAGE_MAXが0のときのための対応
        FirstRow = IMAGE_MAX - 1;
    }
    
    // ０件のときの対策
   if (([self.tableView numberOfSections] > 0) &&
        ([self.tableView numberOfRowsInSection:0] > 0)){
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:FirstRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    // section = 1より、セル数は一通り。すなわち画像の数を返す
    return IMAGE_MAX;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // ファイル名取得
    int ans = indexPath.row;
    NSString* fileName = [files objectAtIndex:(IMAGE_MAX - indexPath.row -1)];
    NSString* cellImageName = [publicDocumentsDir stringByAppendingPathComponent:fileName];
    // イメージデータ取得
    NSData* img_data = [NSData dataWithContentsOfFile:cellImageName];
    cell.imageView.image = [[UIImage alloc] initWithData:img_data];
    //cell.imageView.image = [UIImage imageNamed:cellImageName];
    
    // UITableViewが時計回りに90°回転しているので、cell のコンテンツビューを 反時計回りに90°回転させる。
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI * (-90) / 180.0f);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select = %d",indexPath.row);
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



@end
