//
//  VideoLikeVC.m
//  NPlus
//
//  Created by Anh Le Duc on 10/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "VideoLikeVC.h"
#import "CuaTuiCell.h"
@interface VideoLikeVC ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    UIRefreshControl *_refreshControl;
    UIImageView *_imgNoData;
}

@end

@implementation VideoLikeVC

-(NSString *)screenNameGA{
    return [self parent];
}

- (NSString*)parent{
    id parentVC = self.parentViewController.parentViewController;
    if (parentVC && [parentVC respondsToSelector:@selector(screenNameGA)]) {
        return [NSString stringWithFormat:@"%@.VideoLike", [parentVC screenNameGA]];
    }
    return @"NotSet";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeAction) name:kLikedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeAction) name:kUnlikedNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_bg"];
    _cvMain.layer.contents = (id)stretchableImage.CGImage;
    _cvMain.layer.contentsScale = [UIScreen mainScreen].scale;
    _cvMain.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
    _cvMain.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _cvMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    self.dataView = _cvMain;
    [self setBackgroundHeader];
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(reloadTableViewDataSource) forControlEvents:UIControlEventValueChanged];
    [self.cvMain addSubview:_refreshControl];
    
    _imgNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 224, 151)];
    _imgNoData.center = CGPointMake(SCREEN_SIZE.width/2, 140);
    [_imgNoData setImage:[UIImage imageNamed:@"personal_default"]];
    
    _imgNoData.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imgNoData];
}

- (void)didLogin{
    [_cvMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self reloadTableViewDataSource];
}

- (void)likeAction {
    [self loadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLoginNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
    [_cvMain registerNib:[UINib nibWithNibName:@"CuaTuiCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"cuaTuiCellId"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataSources.count == 0) {
        [self reloadTableViewDataSource];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CuaTuiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cuaTuiCellId" forIndexPath:indexPath];
    if (indexPath.row >= self.dataSources.count) {
        return cell;
    }
    Video *video = [self.dataSources objectAtIndex:indexPath.row];
    [cell.lbTitle setText:video.video_title];
    [cell.lbTime setText:video.time];
    [cell.imgItem setImageWithURL:[NSURL URLWithString:video.video_image] placeholderImage:[UIImage imageNamed:@"default_video"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float delta = 0.835f;
    float width = (SCREEN_WIDTH - 28)/2;
    float height = width * delta;
    return CGSizeMake(width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    
    UICollectionReusableView *theView;
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:theIndexPath];
        UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_header"];
        theView.layer.contents = (id)stretchableImage.CGImage;
        theView.layer.contentsScale = [UIScreen mainScreen].scale;
        theView.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
        theView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"collection_header"]];
    } else {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:theIndexPath];
        UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_footer"];
        theView.layer.contents = (id)stretchableImage.CGImage;
        theView.layer.contentsScale = [UIScreen mainScreen].scale;
        theView.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
        theView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"collection_footer"]];
    }
    
    return theView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataSources.count) {
        return;
    }
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Video class]]) {
        Video *video = (Video*)obj;
        Channel *channel = [[Channel alloc] init];
        channel.channelName = video.video_title;
        channel.channelDes = @"";
//        show.lstVideo = @[video];
        NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
        nowPlayer.type = @"VideoFull";
        nowPlayer.curShow = channel;
        nowPlayer.curId = video.video_id;
        nowPlayer.lstVideo = @[video];
        [nowPlayer loadDataVideoIndex:0];
        [nowPlayer showPlayer:YES withAnimation:YES];
    }
    
    
}

- (void)loadMore{
    
    self.curPage++;
    [self loadData];
}

-(void)loadData{
    if (APPDELEGATE.user) {
        if (self.dataSources.count == 0) {
            [self showConnectionErrorView:NO];
            [self showLoadingDataView:YES];
        }
        [[APIController sharedInstance] getVideoLikedWithPageIndex:[NSString stringWithFormat:@"%ld", (long)self.curPage] completed:^(NSArray *results, BOOL isMore) {
            self.isLoadMore = isMore;
            if (self.curPage == kFirstPage) {
                [self.dataSources removeAllObjects];
                [self.dataSources addObjectsFromArray:results];
            }else{
                [self.dataSources addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
            if (self.dataSources.count == 0) {
                _imgNoData.hidden = NO;
                self.cvMain.hidden = YES;
            }else{
                _imgNoData.hidden = YES;
                self.cvMain.hidden = NO;
            }
        } failed:^(NSError *error) {
            if (self.dataSources.count == 0) {
                [self showLoadingDataView:NO];
                if (APPDELEGATE.internetConnnected) {
                    _imgNoData.hidden = NO;
                    _cvMain.hidden = YES;
                }else{
                    [self showConnectionErrorView:YES];
                }
            }
        }];
        
    }else{
        //show view login
        self.cvMain.hidden = YES;
        _imgNoData.hidden = YES;
    }
}

-(void)finishLoadData{
    [super finishLoadData];
    [_refreshControl endRefreshing];
}
@end
