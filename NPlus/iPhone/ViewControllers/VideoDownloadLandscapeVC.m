//
//  VideoDownloadLandscapeVC.m
//  NPlus
//
//  Created by Anh Le Duc on 9/24/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "VideoDownloadLandscapeVC.h"
#import "CollectionDownloadCell.h"
#import "DBHelper.h"
#import "DownloadManager.h"
#import "APIController.h"

static void runOnMainThread(void (^block)(void))
{
    if (!block) return;
    
    if ( [[NSThread currentThread] isMainThread] ) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface VideoDownloadLandscapeVC (){
    NSMutableDictionary *lstDownloaded;
    NSMutableDictionary *lstDownloading;
}

@end

@implementation VideoDownloadLandscapeVC

@synthesize dataSource = _dataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)btnDownload_Tapped:(id)sender {
    NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:nowVC.lstVideo];
    if (_dataSource.count ==1 && [[_dataSource firstObject] isKindOfClass:[Video class]]) {
        Video *video = (Video*)[_dataSource firstObject];
        if (video.link_down == nil) {
            [[APIController sharedInstance] getVideoDetailWithId:video.video_id completed:^(NSArray *results) {
                [_dataSource replaceObjectAtIndex:0 withObject:[results lastObject]];
                [self btnDownload_Tapped:nil];
            } failed:^(NSError *error) {
                
            }];
            return;
        }
        
        [[DownloadManager sharedInstance] downloadVideo:video withQuality:nil completion:^(DownloadManagerCode code) {
            if (code == DownloadManagerCodeFileIsNull) {
                NSString *mess = @"Không tìm thấy link tải về.";
                [APPDELEGATE showToastMessage:mess];
                return;
            }
            if (code == DownloadManagerCodeFileExists) {
                NSString *mess = @"Đang được tải về.";
                [APPDELEGATE showToastMessage:mess];
                return;
            }
            if(code == DownloadManagerCodeFileDownloaded){
                NSString *mess = @"Đã được tải về.";
                [APPDELEGATE showToastMessage:mess];
                return;
            }
            if(code == DownloadManagerCodeAddFinished){
                NSString *mess = @"Đã thêm vào danh sách tải về.";
                [APPDELEGATE showToastMessage:mess];
                return;
            }
            if(code == DownloadManagerCodeDoNotAllowDownload){
                NSString *mess = @"Do yêu cầu của đơn vị sở hữu bản quyền, hiện không cho phép tải video này!";
                [APPDELEGATE showToastMessage:mess];
                return;
            }
        }];
    }
    
}

-(void)loadData{
//    if (data) {
//        [self.dataSource removeAllObjects];
//        [self.dataSource addObjectsFromArray:data];
//        [_cvMain reloadData];
//    }
    NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
    NSArray *lstVideo = nowVC.lstVideo;
    if (lstVideo.count == 1) {
        _btnDownload.hidden = NO;
        _cvMain.hidden = YES;
    }else{
        _btnDownload.hidden = YES;
        _cvMain.hidden = NO;
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:lstVideo];
        [self beforeReload];
        [_cvMain performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [_cvMain layoutIfNeeded];
    }

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadStatusChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lstDownloaded = [[NSMutableDictionary alloc] init];
    lstDownloading = [[NSMutableDictionary alloc] init];
    [_cvMain registerNib:[UINib nibWithNibName:@"CollectionDownloadCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectionDownloadCellId"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadChangeStatus:) name:kDownloadStatusChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    _dataSource = [[NSMutableArray alloc] init];
    _cvMain.backgroundColor = [UIColor clearColor];
    _cvMain.dataSource = self;
    _cvMain.delegate = self;
    
    UIImage *normalImage = [UIImage imageNamed:@"bg_btn"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    UIImage *stretchableNormalImage = [normalImage resizableImageWithCapInsets:insets];
    [_btnDownload setBackgroundImage:stretchableNormalImage forState:UIControlStateNormal];
    
}

- (void)beforeReload{
    if (lstDownloading) {
        [lstDownloading removeAllObjects];
        lstDownloading = nil;
    }
    lstDownloading = [[NSMutableDictionary alloc] init];
    NSArray *lst = [[DBHelper sharedInstance] lstVideoDownloading];
    for (Video *video in lst) {
        [lstDownloading setObject:[NSNumber numberWithBool:YES] forKey:video.video_id];
    }
    if (lstDownloaded) {
        [lstDownloaded removeAllObjects];
        lstDownloaded = nil;
    }
    lstDownloaded = [[NSMutableDictionary alloc] init];
    lst = [[DBHelper sharedInstance] lstVideoDownloaded];
    for (Video *video in lst) {
        [lstDownloaded setObject:[NSNumber numberWithBool:YES] forKey:video.video_id];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionDownloadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionDownloadCellId" forIndexPath:indexPath];
    if (indexPath.row >= self.dataSource.count) {
        return cell;
    }
    Video *video = [self.dataSource objectAtIndex:indexPath.row];
    if ([lstDownloaded objectForKey:video.video_id]) {
        [cell setCollectionDownloadCellType:CollectionDownloadCellTypeDownloaded];
        cell.imgBG.backgroundColor = RGB(64, 91, 101);
    }else if ([lstDownloading objectForKey:video.video_id]){
        [cell setCollectionDownloadCellType:CollectionDownloadCellTypeDownloading];
    }else{
        [cell setCollectionDownloadCellType:CollectionDownloadCellTypeNormal];
        cell.imgBG.backgroundColor = RGB(64, 91, 101);
    }
    cell.lbTitle.textColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.lbTitle.text = [NSString stringWithFormat:@"%d", (int)indexPath.row + 1];
    return cell;
}

- (BOOL)videoIsDownloaded:(Video*)video{
    NSArray *arr = [[DBHelper sharedInstance] lstVideoDownloaded];
    for (Video *vi in arr) {
        if ([video isEqualToVideo:vi]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)videoIsDownloading:(Video*)video{
    NSArray *arr = [[DBHelper sharedInstance] lstVideoDownloading];
    for (Video *vi in arr) {
        if ([video isEqualToVideo:vi]) {
            return YES;
        }
    }
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(53, 35);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    Video *video = [_dataSource objectAtIndex:indexPath.row];
    if (video.link_down == nil) {
        [[APIController sharedInstance] getVideoDetailWithId:video.video_id completed:^(NSArray *results) {
            video.link_down = [[results lastObject] link_down];
            [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
            [self reloadData];
        } failed:^(NSError *error) {
            
        }];
        return;
    }
    
    //NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
    
    [[DownloadManager sharedInstance] downloadVideo:video withQuality:nil completion:^(DownloadManagerCode code) {
//        if ([NSThread isMainThread]) {
//            NSLog(@"main thread");
//        }else{
//            NSLog(@"no main thread");
//        }
//        NSLog(@"call back: %d", code);
        if (code == DownloadManagerCodeFileIsNull) {
            NSString *mess = @"Không tìm thấy link tải về.";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        if (code == DownloadManagerCodeFileExists) {
            NSString *mess = @"Đang được tải về.";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        if(code == DownloadManagerCodeFileDownloaded){
            NSString *mess = @"Đã được tải về.";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        if(code == DownloadManagerCodeAddFinished){
            NSString *mess = @"Đã thêm vào danh sách tải về.";
            [APPDELEGATE showToastMessage:mess];
            [self reloadData];
            
            return;
        }
        if(code == DownloadManagerCodeDoNotAllowDownload){
            NSString *mess = @"Do yêu cầu của đơn vị sở hữu bản quyền, hiện không cho phép tải video này!";
            [APPDELEGATE showToastMessage:mess];
            return;
        }
        
    }];
    
}
- (void)downloadChangeStatus: (NSNotification*)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger code = [[userInfo objectForKey:@"code"] integerValue];
    if (code != DownloadResultCodeUpdated) {
        [self reloadData];
    }
}

-(void)reloadData{
    runOnMainThread(^{
        NSArray* indexPahts = [_cvMain indexPathsForVisibleItems];
        if (indexPahts.count == 0) {
            return;
        }
        [self beforeReload];
        [_cvMain reloadItemsAtIndexPaths:indexPahts];
    });
    
}
@end
