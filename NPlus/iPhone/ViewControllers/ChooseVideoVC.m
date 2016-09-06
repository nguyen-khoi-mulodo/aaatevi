//
//  ChooseVideoVC.m
//  NPlus
//
//  Created by Anh Le Duc on 8/28/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "ChooseVideoVC.h"
#import "DBHelper.h"
#import "CollectionDownloadCell.h"
#import "CustomFlowLayout.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAIFields.h"

#define kSECTION_VIDEO_COUNT 0

static void runOnMainThread(void (^block)(void))
{
    if (!block) return;
    
    if ( [[NSThread currentThread] isMainThread] ) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface ChooseVideoVC ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    float heightSection;
    NSInteger curIndex;
    BOOL _isDownload;
    
    NSMutableDictionary *lstDownloaded;
    NSMutableDictionary *lstDownloading;
}

@end

@implementation ChooseVideoVC
//@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

-(NSString *)screenNameGA{
    return @"VideoDetail.ChooseVideo";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_cvItems registerNib:[UINib nibWithNibName:@"CollectionDownloadCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectionDownloadCellId"];
    [_cvItems registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_cvItems registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    self.dataSources = [[NSMutableArray alloc] init];
    _cvItems.bounces = NO;
    _cvItems.dataSource = self;
    _cvItems.delegate = self;
    _cvItems.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.dataView = _cvItems;
    curIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectedIndex:) name:kUpdateIndexVideoNotification object:nil];
}

- (void)beforeReload{
    if (lstDownloading) {
        [lstDownloading removeAllObjects];
        lstDownloading = nil;
    }
    lstDownloading = [[NSMutableDictionary alloc] init];
//    NSArray *lst = [[DBHelper sharedInstance] lstVideoDownloading];
//    for (Video *video in lst) {
//        [lstDownloading setObject:[NSNumber numberWithBool:YES] forKey:video.video_id];
//    }
//    if (lstDownloaded) {
//        [lstDownloaded removeAllObjects];
//        lstDownloaded = nil;
//    }
//    lstDownloaded = [[NSMutableDictionary alloc] init];
//    lst = [[DBHelper sharedInstance] lstVideoDownloaded];
//    for (Video *video in lst) {
//        [lstDownloaded setObject:[NSNumber numberWithBool:YES] forKey:video.video_id];
//    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateIndexVideoNotification object:nil];
}

-(void)setVideoItems:(NSArray *)lst selectedAtIndex:(NSInteger)index{
    if (lst) {
        curIndex = index;
        [self.dataSources removeAllObjects];
        [self.dataSources addObjectsFromArray:[lst mutableCopy]];
        [self beforeReload];
        [_cvItems performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(refreshBackground) userInfo:nil repeats:NO];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _cvItems.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_bg"];
    _cvItems.layer.contents = (id)stretchableImage.CGImage;
    _cvItems.layer.contentsScale = [UIScreen mainScreen].scale;
    _cvItems.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
    [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(refreshBackground) userInfo:nil repeats:NO];
}

- (void)refreshBackground{
    [self setBackgroundFooter];
    _cvItems.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)viewControllerTitle{
    return @"Chọn video";
}

- (void)updateSelectedIndex:(NSNotification*)notification{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo && [userInfo objectForKey:@"index"]) {
        NSInteger index = [[userInfo objectForKey:@"index"] integerValue];
        curIndex = index;
        [_cvItems performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    
    UICollectionReusableView *theView;
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:theIndexPath];
        if (self.dataSources.count > 0) {
            
            theView.backgroundColor = BACKGROUND_COLOR;
            
            UIView *videoCount = [theView viewWithTag:100];
            if (videoCount == nil) {
                videoCount = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 45)];
                UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_bg"];
                videoCount.layer.contents = (id)stretchableImage.CGImage;
                videoCount.layer.contentsScale = [UIScreen mainScreen].scale;
                videoCount.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
                
                UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 15)];
                lbDesc.text = @"Chọn video";
                lbDesc.textColor = RGB(116, 116, 116);
                lbDesc.backgroundColor = [UIColor clearColor];
                lbDesc.font = [UIFont systemFontOfSize:13.0f];
                [lbDesc sizeToFit];
                [videoCount addSubview:lbDesc];
                
                UILabel *lbCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 10, 100, 15)];
                lbCount.backgroundColor = [UIColor clearColor];
                lbCount.textAlignment = NSTextAlignmentRight;
                
                lbCount.font = [UIFont systemFontOfSize:13.0f];
                lbCount.textColor  =RGB(116, 116, 116);
                lbCount.tag = 200;
                [videoCount addSubview:lbCount];
                UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH - 30, 1)];
                sep.backgroundColor = RGB(231, 231, 231);
                [videoCount addSubview:sep];
                videoCount.tag = 100;
                [theView addSubview:videoCount];
            }
            
            UILabel *lb = (UILabel*)[videoCount viewWithTag:200];
            lb.text = [NSString stringWithFormat:@"%lu video", (unsigned long)self.dataSources.count];
            

            
        }else{
            theView.backgroundColor = [UIColor clearColor];
        }
        
    } else {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:theIndexPath];
        if (self.dataSources.count > 0) {
            UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_footer"];
            theView.layer.contents = (id)stretchableImage.CGImage;
            theView.layer.contentsScale = [UIScreen mainScreen].scale;
            theView.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
        }else{
            theView.backgroundColor = [UIColor clearColor];
        }
    }
    
    return theView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionDownloadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionDownloadCellId" forIndexPath:indexPath];
    if (indexPath.row >= self.dataSources.count) {
        return cell;
    }
    Video *video = [self.dataSources objectAtIndex:indexPath.row];
    if (_isDownload) {
        if ([lstDownloaded objectForKey:video.video_id]) {
            [cell setCollectionDownloadCellType:CollectionDownloadCellTypeDownloaded];
        }else if ([lstDownloading objectForKey:video.video_id]){
            [cell setCollectionDownloadCellType:CollectionDownloadCellTypeDownloading];
        }else{
            [cell setCollectionDownloadCellType:CollectionDownloadCellTypeNormal];
        }
    }else{
        if ([lstDownloaded objectForKey:video.video_id]) {
            [cell setCollectionDownloadCellType:CollectionDownloadCellTypeDownloaded];
        }else{
            [cell setCollectionDownloadCellType:CollectionDownloadCellTypeNormal];
        }
        if (curIndex == indexPath.row) {
            cell.imgBG.backgroundColor = COLOR_MAIN_BLUE;
            cell.lbTitle.textColor = [UIColor whiteColor];
        }
    }
    cell.lbTitle.text = [NSString stringWithFormat:@"%d", (int)indexPath.row + 1];
    return cell;
}

//- (BOOL)videoIsDownloaded:(Video*)video{
//    NSArray *arr = [[DBHelper sharedInstance] lstVideoDownloaded];
//    for (Video *vi in arr) {
//        if ([video isEqualToVideo:vi]) {
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (BOOL)videoIsDownloading:(Video*)video{
//    NSArray *arr = [[DBHelper sharedInstance] lstVideoDownloading];
//    for (Video *vi in arr) {
//        if ([video isEqualToVideo:vi]) {
//            return YES;
//        }
//    }
//    return NO;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float delta = 0.648f;
    float width = (MIN(SCREEN_WIDTH, SCREEN_HEIGHT) - 50)/5;
    float height = width * delta;
    return CGSizeMake(width, height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataSources.count) {
        return;
    }
    if (!_isDownload) {
        curIndex = indexPath.row;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(chooseVideoVC:didSelectedAtIndex:)]) {
        [_delegate chooseVideoVC:self didSelectedAtIndex:indexPath.row];
    }
}
-(void)setStateDownload:(BOOL)isDownload{
    _isDownload = isDownload;
    [self reloadData];
}

-(void)reloadData{
    runOnMainThread(^{
        NSArray* indexPahts = [_cvItems indexPathsForVisibleItems];
        if (indexPahts.count == 0) {
            return;
        }
        [self beforeReload];
        [_cvItems reloadItemsAtIndexPaths:indexPahts];
    });
    _cvItems.contentInset = UIEdgeInsetsMake(0, 0, _isDownload ? 35 : 0, 0);
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value: _isDownload ? @"iOS.VideoDetail.ChooseVideoDownload" : @"iOS.VideoDetail.ChooseVideo"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}
@end
