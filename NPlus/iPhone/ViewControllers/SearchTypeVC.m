//
//  SearchTypeVC.m
//  NPlus
//
//  Created by Anh Le Duc on 10/2/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "SearchTypeVC.h"
#import "CollectionBaseCell.h"
#import "NowPlayerVC.h"
#import "ListVideoVC.h"
@interface SearchTypeVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation SearchTypeVC
@synthesize type = _type;
@synthesize keyword = _keyword;
@synthesize genre_id = _genre_id;

-(NSString *)screenNameGA{
    return [self parent];
}

- (NSString*)parent{
    id parentVC = self.parentViewController.parentViewController;
    if (parentVC && [parentVC respondsToSelector:@selector(screenNameGA)]) {
        return [NSString stringWithFormat:@"%@.%@", [parentVC screenNameGA], self.type];
    }
    return @"NotSet";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_bg"];
    _cvMain.layer.contents = (id)stretchableImage.CGImage;
    _cvMain.layer.contentsScale = [UIScreen mainScreen].scale;
    _cvMain.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
    
    _cvMain.dataSource = self;
    _cvMain.delegate = self;
    _cvMain.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.dataView = _cvMain;
    _cvMain.hidden = YES;
    _cvMain.alwaysBounceVertical = YES;
    [self setBackgroundHeader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDataNotFoundNoti) name:kDataNotExistNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataSources.count == 0) {
        [self loadData];
    }
}

-(void)loadData{
    if (self.dataSources.count == 0) {
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    [[APIController sharedInstance] getSearchShow:_keyword withGenre:_genre_id withPageIndex:[NSString stringWithFormat:@"%ld", (long)self.curPage] completed:^(NSArray *results, BOOL isMore) {
        self.isLoadMore = isMore;
        if (self.curPage == kFirstPage) {
            [self.dataSources removeAllObjects];
            [self.dataSources addObjectsFromArray:results];
        }else{
            [self.dataSources addObjectsFromArray:results];
        }
        [self finishLoadData];
//        self.dataView.hidden = YES;
        [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(loadDataView) userInfo:nil repeats:NO];
    } failed:^(NSError *error) {
        NSDictionary *dic = error.userInfo;
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            if (dic && [[[dic objectForKey:@"error"] objectForKey:@"code"] integerValue] == 224) {
                [self showConnectionErrorView:NO];
                [self showNoDataView:YES];
                
            }else{
                [self showConnectionErrorView:YES];
                [self showNoDataView:NO];
                
            }
        }
    }];
}

- (void)loadDataView{
    [self showLoadingDataView:NO];
    [self setBackgroundFooter];
    self.dataView.hidden = NO;
    if (self.dataSources.count == 0) {
        [self showNoDataView:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_cvMain registerNib:[UINib nibWithNibName:@"CollectionBaseCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"collectionBaseCellId"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionBaseCellId" forIndexPath:indexPath];
    if (indexPath.row >= self.dataSources.count) {
        return cell;
    }
//    Channel *item = [self.dataSources objectAtIndex:indexPath.row];
//    [cell.lbTitle setText:item.show_title];
//    //    [cell.lbTitle sizeToFit];
//    NSString *imageName = @"default_tvshow";
//    if (item.isMovie) {
//        imageName = @"default_movie";
//    }
//    [cell.imgItem setImageWithURL:[NSURL URLWithString:item.image_thumb] placeholderImage:[UIImage imageNamed:imageName]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_type isEqualToString:@"movie"]||[_type isEqualToString:@"cartoon"]) {
        float delta = 2.0f;
        float width = (SCREEN_WIDTH - 35)/3;
        float height = width * delta;
        return CGSizeMake(width, height);
    }else{
        float delta = 1.267f;
        float width = (SCREEN_WIDTH - 28)/2;
        float height = width * delta;
        return CGSizeMake(width, height);
    }
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
    CGSize size = [self collectionView:collectionView layout:self sizeForItemAtIndexPath:indexPath];
    if ([obj isKindOfClass:[Channel class]]) {
        Channel *item = (Channel*)obj;
//        if ([item.type isEqualToString:@"Single"]) {
//            //open player center
//            NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
//            nowPlayer.type = @"Single";
//            nowPlayer.curId = item.show_id;
//            nowPlayer.curShow = item;
//            nowPlayer.itemCollectionType = (size.width > 100) ? kItemCollectionTypeTVShow : kItemCollectionTypeMovies;
//            [nowPlayer loadData];
//            [nowPlayer showPlayer:YES withAnimation:YES];
//        }else if ([item.type isEqualToString:@"Serial"]){
//            ListVideoVC *lstVideo = [[ListVideoVC alloc] initWithNibName:@"ListVideoVC" bundle:nil];
//            lstVideo.currentItem = item;
//            lstVideo.itemCollectionType = (size.width > 100) ? kItemCollectionTypeTVShow : kItemCollectionTypeMovies;
//            [self.navigationController pushViewController:lstVideo animated:YES];
//        }
    }
}

@end
