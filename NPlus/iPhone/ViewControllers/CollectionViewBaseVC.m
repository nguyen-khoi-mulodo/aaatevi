//
//  CollectionViewBaseVC.m
//  NPlus
//
//  Created by Anh Le Duc on 8/19/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "CollectionViewBaseVC.h"


#import "CollectionBaseCell.h"
#import "CuaTuiCell.h"
#import "SearchVC.h"
#import "NowPlayerVC.h"
#import "ListVideoVC.h"
@interface CollectionViewBaseVC(){
    UIRefreshControl *refreshControl;
}

@end

@implementation CollectionViewBaseVC
@synthesize currentTab = _currentTab;
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
    [self.navigationItem.titleView setHidden:YES];
    //self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_bg"];
    _cvMain.layer.contents = (id)stretchableImage.CGImage;
    _cvMain.layer.contentsScale = [UIScreen mainScreen].scale;
    _cvMain.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
    _cvMain.dataSource = self;
    _cvMain.delegate = self;
    self.dataView = _cvMain;
    [self setBackgroundHeader];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(reloadTableViewDataSource) forControlEvents:UIControlEventValueChanged];
    [self.cvMain addSubview:refreshControl];
    self.cvMain.alwaysBounceVertical = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataSources.count == 0) {
        [self loadData];
    }
}

- (void)loadData{
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_cvMain registerNib:[UINib nibWithNibName:@"CuaTuiCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"cuaTuiCellId"];
    [_cvMain registerNib:[UINib nibWithNibName:@"CollectionBaseCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"collectionBaseCellId"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Channel class]]) {
        CollectionBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionBaseCellId" forIndexPath:indexPath];
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
        Channel *show = (Channel*)item;
//        if (show.isMovie) {
//            float delta = 2.0f;
//            float width = (SCREEN_WIDTH - 35)/3;
//            float height = width * delta;
//            return CGSizeMake(width, height);
//        }else{
//            float delta = 1.267f;
//            float width = (SCREEN_WIDTH - 28)/2;
//            float height = width * delta;
//            return CGSizeMake(width, height);
//        }
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
    if ([obj isKindOfClass:[Channel class]]) {
        Channel *item = (Channel*)obj;
        
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
    }else if([obj isKindOfClass:[Video class]]){
        Video *video = (Video*)obj;
        Channel *show = [[Channel alloc] init];
//        show.show_title = video.video_title;
//        show.show_description = @"";
        NowPlayerVC *nowPlayer = APPDELEGATE.nowPlayerVC;
        nowPlayer.type = @"VideoFull";
        nowPlayer.curShow = show;
        nowPlayer.curId = video.video_id;
        nowPlayer.lstVideo = @[video];
        [nowPlayer loadDataVideoIndex:0];
        [nowPlayer showPlayer:YES withAnimation:YES];
    }
}



- (IBAction)btnBack_Tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)finishLoadData{
    [super finishLoadData];
    [self showLoadingDataView:NO];
    [refreshControl endRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(setBackgroundFooter) userInfo:nil repeats:NO];
}

@end
