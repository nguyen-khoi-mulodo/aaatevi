//
//  ChooseVideoLandscapeVC.m
//  NPlus
//
//  Created by Anh Le Duc on 9/18/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "ChooseVideoLandscapeVC.h"
#import "CollectionDownloadCell.h"
#import "Video.h"
#import "DBHelper.h"
#import "MyCollectionViewCell.h"
static void runOnMainThread(void (^block)(void))
{
    if (!block) return;
    
    if ( [[NSThread currentThread] isMainThread] ) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface ChooseVideoLandscapeVC (){
    NSInteger curIndex;
    BOOL _isRegisted;
}

@end

@implementation ChooseVideoLandscapeVC
@synthesize dataSource = _dataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setListVideo:(NSArray *)data{
    if (data) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:data];
        [_cvMain reloadData];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_cvMain registerNib:[UINib nibWithNibName:@"CollectionDownloadCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectionDownloadCellId"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadChangeStatus:) name:kDownloadStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectedIndex:) name:kUpdateIndexVideoNotification object:nil];
    _isRegisted = NO;
    _dataSource = [[NSMutableArray alloc] init];
    _cvMain.backgroundColor = [UIColor clearColor];
    _cvMain.dataSource = self;
    _cvMain.delegate = self;
    [_cvMain registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"colCell"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateIndexVideoNotification object:nil];
}

- (void)downloadChangeStatus: (NSNotification*)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger code = [[userInfo objectForKey:@"code"] integerValue];
    if (self.dataSource.count < 2) {
        return;
    }
    if (code != DownloadResultCodeUpdated) {
        [self reloadData];
    }
}

- (void)loadData{
    NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
    NSArray *lst = nowVC.lstVideo;
    curIndex = nowVC.curIndexVideoChoose;
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:lst];
    [_cvMain performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [_cvMain layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _isRegisted = YES;
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isRegisted = NO;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataSource.count;
    return 15;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CollectionDownloadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionDownloadCellId" forIndexPath:indexPath];
//    if (indexPath.row >= self.dataSource.count) {
//        return cell;
//    }
//    Video *video = [self.dataSource objectAtIndex:indexPath.row];
//    if ([self videoIsDownloaded:video]) {
//        [cell setCollectionDownloadCellType:CollectionDownloadCellTypeDownloaded];
//    }else{
//        [cell setCollectionDownloadCellType:CollectionDownloadCellTypeNormal];
//    }
//    cell.imgBG.backgroundColor = RGB(64, 91, 101);
//    cell.lbTitle.textColor = [UIColor whiteColor];
//    cell.layer.borderColor = [UIColor clearColor].CGColor;
//    if (curIndex == indexPath.row) {
//        cell.imgBG.backgroundColor = COLOR_MAIN_BLUE;
//    }
//    cell.lbTitle.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//    return cell;
    MyCollectionViewCell *cell = (MyCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [Utilities loadView:[MyCollectionViewCell class] FromNib:@"MyCollectionViewCell"];
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xBABDBF);
    if (curIndex == indexPath.row) {
        cell.contentView.backgroundColor = UIColorFromRGB(0x4eadf0);
    }
    cell.lblTitle.text = [NSString stringWithFormat:@"%d",(int)indexPath.row + 1];
    return  cell;
}

- (BOOL)videoIsDownloaded:(Video*)video{
//    NSArray *arr = [[DBHelper sharedInstance] lstVideoDownloaded];
//    for (Video *vi in arr) {
//        if ([video isEqualToVideo:vi]) {
//            return YES;
//        }
//    }
    return NO;
}

- (BOOL)videoIsDownloading:(Video*)video{
//    NSArray *arr = [[DBHelper sharedInstance] lstVideoDownloading];
//    for (Video *vi in arr) {
//        if ([video isEqualToVideo:vi]) {
//            return YES;
//        }
//    }
    return NO;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(53, 35);
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row >= self.dataSource.count) {
//        return;
//    }
    curIndex = indexPath.row;
//    NowPlayerVC *nowVC = APPDELEGATE.nowPlayerVC;
//    Video *video = [_dataSource objectAtIndex:indexPath.row];
//    if (nowVC && video) {
//        [nowVC setCurIndexVideoChoose:indexPath.row];
//        [nowVC playWithVideo:video];
//    }
    NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
    nowPlayer.type = @"Single";
    //    nowPlayer.curId = item.show_id;
    //    nowPlayer.curShow = item;
    [nowPlayer loadDataVideoIndex:(int)curIndex];
    //[nowPlayer showPlayer:YES withAnimation:YES];
    UICollectionViewCell *precell = [_cvMain cellForItemAtIndexPath:[NSIndexPath indexPathForRow:curIndex inSection:0]];
    precell.contentView.backgroundColor = UIColorFromRGB(0xBABDBF);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColorFromRGB(0x4eadf0);
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideControlPlayerNotification object:nil];
}

- (void)updateSelectedIndex:(NSNotification*)notification{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo && [userInfo objectForKey:@"index"]) {
        NSInteger index = [[userInfo objectForKey:@"index"] integerValue];
        curIndex = index;
        [self reloadData];
    }
}

-(void)reloadData{
    runOnMainThread(^{
        NSArray* indexPahts = [_cvMain indexPathsForVisibleItems];
        if (indexPahts.count == 0) {
            return;
        }
        [_cvMain reloadItemsAtIndexPaths:indexPahts];
    });
    
}

@end
