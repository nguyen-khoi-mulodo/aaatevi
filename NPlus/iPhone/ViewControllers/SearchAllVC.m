//
//  SearchAllVC.m
//  NPlus
//
//  Created by Anh Le Duc on 10/2/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "SearchAllVC.h"
#import "SearchCell.h"
#import "CuaTuiCell.h"
#import "Channel.h"
#import "NowPlayerVC.h"
#import "ListVideoVC.h"
@interface SearchAllVC ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    BOOL isShowMore, isVideoMore;
    NSInteger curPageShow, curPageVideo;
    NSInteger process;
}

@end

@implementation SearchAllVC
@synthesize keyword = _keyword;

-(NSString *)screenNameGA{
    return [self parent];
}

- (NSString*)parent{
    id parentVC = self.parentViewController.parentViewController;
    if (parentVC && [parentVC respondsToSelector:@selector(screenNameGA)]) {
        return [NSString stringWithFormat:@"%@.All", [parentVC screenNameGA]];
    }
    return @"NotSet";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataSources removeAllObjects];
    isShowMore = YES;
    isVideoMore = YES;
    process = 0;
    curPageShow = 1;
    curPageVideo = 1;
    // Do any additional setup after loading the view from its nib.
//    _tbMain.dataSource = self;
//    _tbMain.delegate = self;
//    _tbMain.clipsToBounds = NO;
//    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tbMain.backgroundColor = BACKGROUND_COLOR;
//    _tbMain.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
//    self.dataView = _tbMain;
    
    // Do any additional setup after loading the view from its nib.
    UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_bg"];
    _cvMain.layer.contents = (id)stretchableImage.CGImage;
    _cvMain.layer.contentsScale = [UIScreen mainScreen].scale;
    _cvMain.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
    _cvMain.bounces = NO;
    _cvMain.dataSource = self;
    _cvMain.delegate = self;
    _cvMain.alwaysBounceVertical = YES;
    self.dataView = _cvMain;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDataNotFoundNoti) name:kDataNotExistNotification object:nil];
}

-(NSString *)viewControllerTitle{
    return @"Tất cả";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataSources.count == 0) {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    process = 0;
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    if (!isShowMore) {
        process ++;
        [self renderData];
    }else{
        [[APIController sharedInstance] getSearchShow:_keyword withGenre:@"0" withPageIndex:[NSString stringWithFormat:@"%ld", (long)curPageShow] completed:^(NSArray *results, BOOL isMore) {
            isShowMore = isMore;
            [self.dataSources addObjectsFromArray:results];
            process ++;
            [self renderData];
        } failed:^(NSError *error) {
            process ++;
            [self renderData];
        }];
    }
    if (!isVideoMore) {
        process ++;
        [self renderData];
    }else{
        [[APIController sharedInstance] getSearchVideos:_keyword withPageIndex:[NSString stringWithFormat:@"%ld", (long)curPageVideo] completed:^(NSArray *results, BOOL isMore) {
            isVideoMore = isMore;
            [self.dataSources addObjectsFromArray:results];
            process ++;
            [self renderData];
        } failed:^(NSError *error) {
            process ++;
            [self renderData];
        }];
    }
}

-(void) loadMore
{
    curPageShow++;
    curPageVideo++;
    [self loadData];
}


- (void)renderData{
//    if (process < 2) {
//        return;
//    }
    [self finishLoadData];
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(setBackgroundFooter) userInfo:nil repeats:NO];
    [self showLoadingDataView:NO];
    if (self.dataSources.count == 0) {
        [self showNoDataView:YES];
    }
    if (!APPDELEGATE.internetConnnected && self.dataSources.count == 0) {
        [self showNoDataView:NO];
        [self showConnectionErrorView:YES];
    }
}

- (void)receiveDataNotFoundNoti {
    if (self.dataSources.count == 0) {
        [self showLoadingDataView:NO];
        [self showNoDataView:YES];
    }
    
    if (!APPDELEGATE.internetConnnected && self.dataSources.count == 0) {
        [self showNoDataView:NO];
        [self showConnectionErrorView:YES];
    }
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if (self.dataSources.count == 0) {
            return;
        }
        if(isShowMore || isVideoMore)
        {
            [self loadMore];
            isShowMore = NO;
            isVideoMore = NO;
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!IS_IPAD) {
        [self setBackgroundFooter];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_cvMain registerNib:[UINib nibWithNibName:@"CuaTuiCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"cuaTuiCellId"];
    [_cvMain registerNib:[UINib nibWithNibName:@"SearchCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"searchCellID"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Channel class]]) {
        SearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCellID" forIndexPath:indexPath];
        if (indexPath.row >= self.dataSources.count) {
            return cell;
        }
        Channel *item = (Channel*)obj;
//        [cell.lbTitle setText:item.show_title];
//        NSString *imageName = @"default_tvshow";
//        if (item.isMovie) {
//            imageName = @"default_movie";
//        }
//        [cell.imgItem setImageWithURL:[NSURL URLWithString:item.image_thumb] placeholderImage:[UIImage imageNamed:imageName]];
        return cell;
    }
    if ([obj isKindOfClass:[Video class]]) {
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
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self.dataSources objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[Channel class]]) {
        float width = SCREEN_WIDTH -10;
        float height = 0;
        Channel *show = (Channel*)item;
//        if (!show.isMovie) {
//            height = 90;
//        }else{
//            height = 90 * 1.4f;
//        }
        return CGSizeMake(width, height);
    }
    
    if ([item isKindOfClass:[Video class]]) {
        float delta = 0.835f;
        float width = (SCREEN_WIDTH - 28)/2;
        float height = width * delta;
        return CGSizeMake(width, height);
    }
    
    
    return CGSizeMake(50, 185);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    
    UICollectionReusableView *theView;
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:theIndexPath];
        if (self.dataSources.count > 0) {
            UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_header"];
            theView.layer.contents = (id)stretchableImage.CGImage;
            theView.layer.contentsScale = [UIScreen mainScreen].scale;
            theView.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
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


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataSources.count) {
        return;
    }
    id obj = [self.dataSources objectAtIndex:indexPath.row];
//    if ([obj isKindOfClass:[Show class]]) {
//        Show *item = (Show*)obj;
//        if ([item.type isEqualToString:@"Single"]) {
//            NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
//            nowPlayer.type = @"Single";
//            nowPlayer.curId = item.show_id;
//            nowPlayer.curShow = item;
//            [nowPlayer loadData];
//            [nowPlayer showPlayer:YES withAnimation:YES];
//        }else if ([item.type isEqualToString:@"Serial"]){
//            ListVideoVC *lstVideo = [[ListVideoVC alloc] initWithNibName:@"ListVideoVC" bundle:nil];
//            lstVideo.currentItem = item;
//            [self.navigationController pushViewController:lstVideo animated:YES];
//        }
//    }else if([obj isKindOfClass:[Video class]]){
//        Video *video = (Video*)obj;
//        Show *show = [[Show alloc] init];
//        show.show_title = video.video_title;
//        show.show_description = @"";
//        NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
//        nowPlayer.type = @"VideoFull";
//        nowPlayer.curShow = show;
//        nowPlayer.curId = video.video_id;
//        nowPlayer.lstVideo = @[video];
//        [nowPlayer loadData];
//        [nowPlayer showPlayer:YES withAnimation:YES];
//    }
}


//#pragma mark - uitableview delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataSource.count;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    id obj = [self.dataSource objectAtIndex:indexPath.row];
//    if ([obj isKindOfClass:[Show class]]) {
//        Show *show = (Show*)obj;
//        if (show.isMovie) {
//            return 130;
//        }else{
//            return 90;
//        }
//    }
//    return 90.0f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *listVideoCellId = @"searchAllCellID";
//    
//    SearchAllCell *cell = (SearchAllCell *)[tableView dequeueReusableCellWithIdentifier:listVideoCellId];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchAllCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//    id obj = [self.dataSource objectAtIndex:indexPath.row];
//    if ([obj isKindOfClass:[Show class]]) {
//        Show *item = (Show*)obj;
//        cell.lbTitle.text = item.show_title;
//        [cell.imgItem setImageWithURL:[NSURL URLWithString:item.image_thumb] placeholderImage:[UIImage imageNamed:@"default_video"]];
//    }
//    [cell.imgBG setImage:[self cellBackgroundForRowAtIndexPath:indexPath]];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell setBackgroundColor:[UIColor clearColor]];
//}
//
//- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger rowCount = [self tableView:_tbMain numberOfRowsInSection:0];
//    NSInteger rowIndex = indexPath.row;
//    UIImage *background = nil;
//    
//    if (self.dataSource.count == 1) {
//        background = [UIImage imageNamed:@"theloai_cell_group"];
//        UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
//        UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
//        return stretchableImage;
//    }
//    
//    if (rowIndex == 0) {
//        background = [UIImage imageNamed:@"theloai_cell_top"];
//    } else if (rowIndex == rowCount - 1) {
//        background = [UIImage imageNamed:@"theloai_cell_bottom"];
//    } else {
//        background = [UIImage imageNamed:@"theloai_cell_midle"];
//    }
//    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
//    UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
//    return stretchableImage;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row >= self.dataSource.count) {
//        return;
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    id obj = [self.dataSource objectAtIndex:indexPath.row];
//    if ([obj isKindOfClass:[Show class]]) {
//        Show *item = (Show*)obj;
//        if ([item.type isEqualToString:@"Single"]) {
//            //open player center
//            NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
//            nowPlayer.type = @"Single";
//            nowPlayer.curId = item.show_id;
//            nowPlayer.curShow = item;
//            [nowPlayer loadData];
//            [nowPlayer showPlayer:YES withAnimation:YES];
//        }else if ([item.type isEqualToString:@"Serial"]){
//            ListVideoVC *lstVideo = [[ListVideoVC alloc] initWithNibName:@"ListVideoVC" bundle:nil];
//            lstVideo.currentItem = item;
//            [self.navigationController pushViewController:lstVideo animated:YES];
//        }
//    }
//}

@end
