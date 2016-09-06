//
//  VideoOtherVC.m
//  NPlus
//
//  Created by Anh Le Duc on 8/28/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "VideoOtherVC.h"
#import "CollectionBaseCell.h"
#import "ListVideoVC.h"
#import "UIViewController+AKTabBarController.h"
#import "AKTabBarController.h"

#import "CustomVideoCell.h"
@interface VideoOtherVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) kItemCollectionType itemImageType;

@end

@implementation VideoOtherVC
@synthesize itemImageType = _itemImageType;

-(NSString *)screenNameGA{
    return @"VideoDetail.VideoOther";
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
    self.view.backgroundColor = BACKGROUND_COLOR;
    _itemImageType = kItemCollectionTypeMovies;
    UIImage *stretchableImage = (id)[UIImage imageNamed:@"collection_bg"];
    _cvMain.layer.contents = (id)stretchableImage.CGImage;
    _cvMain.layer.contentsScale = [UIScreen mainScreen].scale;
    _cvMain.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
    _cvMain.dataSource = self;
    _cvMain.delegate = self;
    _cvMain.hidden = YES;
//    self.dataView = _cvMain;
//    [self setBackgroundHeader];
    
    _tbMain.contentInset = UIEdgeInsetsMake(5.0f, 0, 5.0f, 0);
    _tbMain.backgroundColor = [UIColor clearColor];
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setDataViewIsTable:(BOOL)isTable{
    if (isTable) {
        _tbMain.hidden  = NO;
        _cvMain.hidden = YES;
        self.dataView = _tbMain;
    }else{
        _cvMain.hidden = NO;
        _tbMain.hidden = YES;
        self.dataView = _cvMain;
        [self setBackgroundHeader];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)viewControllerTitle{
    return @"Liên quan";
}

-(void)setShowRelated:(NSArray *)lst withType:(kItemCollectionType)type{
    if (lst && lst.count>0) {
        self.itemImageType  = type;
        [self.dataSources removeAllObjects];
        [self.dataSources addObjectsFromArray:lst];
        _cvMain.hidden = NO;
        _tbMain.hidden = YES;
        [self.cvMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [self finishLoadData];
    }
}

-(void)setVideoRelated:(NSArray *)lst{
    if (lst && lst.count>0) {
        [self.dataSources removeAllObjects];
        [self.dataSources addObjectsFromArray:lst];
        _tbMain.hidden = NO;
        _cvMain.hidden = YES;
        [self.tbMain scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [_tbMain reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_cvMain registerNib:[UINib nibWithNibName:@"CollectionBaseCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"collectionBaseCellId"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_cvMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return self.dataSource.count;
    return 45;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionBaseCellId" forIndexPath:indexPath];
    Channel *item = [self.dataSources objectAtIndex:indexPath.row];
//    [cell.lbTitle setText:item.show_title];
//
//    NSString *imageName = @"default_tvshow";
//    if (item.isMovie) {
//        imageName = @"default_movie";
//    }
//    [cell.imgItem setImageWithURL:[NSURL URLWithString:item.image_thumb] placeholderImage:[UIImage imageNamed:imageName]];
    return cell;
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
    if (indexPath.row > self.dataSources.count) {
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
//            [nowPlayer showPlayer:YES withAnimation:NO];
//            
//        }else if ([item.type isEqualToString:@"Serial"]){
//            [APPDELEGATE.nowPlayerVC.player.view youtubeAnimationMinimize:YES];
//            [APPDELEGATE openListVideo:item withType:((size.width > 100) ? kItemCollectionTypeTVShow : kItemCollectionTypeMovies)];
//        }
    }
}

#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"customVideoCellId";
    CustomVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomVideoCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (CustomVideoCell*) currentObject;
                [cell setValue:cellId forKey:@"reuseIdentifier"];
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Video class]]) {
        Video *v = (Video*)obj;
        cell.lbTitle.text = v.video_title;
        cell.lbTitle.textColor = RGB(80, 80, 80);
        cell.lbSinger.textColor = RGB(119, 119, 119);
        
        [cell.imgItem setImageWithURL:[NSURL URLWithString:v.video_image] placeholderImage:[UIImage imageNamed:@"default_video"]];
        cell.imgBackground.image = [self cellBackgroundForRowAtIndexPath:indexPath];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95.0f;
}
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:_tbMain numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (self.dataSources.count == 1) {
        background = [UIImage imageNamed:@"theloai_cell_group"];
        UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
        UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
        return stretchableImage;
    }
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"theloai_cell_top"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"theloai_cell_bottom"];
    } else {
        background = [UIImage imageNamed:@"theloai_cell_midle"];
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 12, 8, 12);
    UIImage *stretchableImage = [background resizableImageWithCapInsets:insets];
    return stretchableImage;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > self.dataSources.count - 1) {
        return;
    }
    id obj = [self.dataSources objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[Video class]]){
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
        [nowPlayer showPlayer:YES withAnimation:NO];
    }
}
@end
