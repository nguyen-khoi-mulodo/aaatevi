//
//  CategoryVC.m
//  NPlus
//
//  Created by Anh Le Duc on 7/29/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "CategoryVC.h"
#import "UIViewController+AKTabBarController.h"
#import "CategoryCell.h"

#import "SearchVC.h"
#import "MovieVC.h"
#import "RelaxVC.h"
#import "TVShowVC.h"
#import "CartoonVC.h"
#import "MusicVC.h"


@interface CategoryVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CategoryVC

-(NSString *)screenNameGA{
    return @"Genre";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)tabImageName
{
	return @"menu_icon_theloai";
}

- (NSString *)activeTabImageName
{
	return @"menu_icon_theloai_hover";
}

- (NSString *)tabTitle
{
	return @"Thể loại";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _viewHeader.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    _viewHeader.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem.titleView setHidden:YES];
    self.view.backgroundColor = BACKGROUND_COLOR;
    _viewHeader.backgroundColor = [UIColor clearColor];
    self.title = @"";
    UIBarButtonItem *btHis = [[UIBarButtonItem alloc] initWithCustomView:_btnHistory];
    UIBarButtonItem *btSearch = [[UIBarButtonItem alloc] initWithCustomView:_btnSearch];
    UIBarButtonItem *lbCategory = [[UIBarButtonItem alloc] initWithCustomView:_lbTitle];
    self.navigationItem.rightBarButtonItems = @[btSearch, btHis];
    self.navigationItem.leftBarButtonItem = lbCategory;
    _lbTitle.textColor = COLOR_MAIN_GRAY;
    _lbTitle.font = [UIFont systemFontOfSize:20.0f];
    _lbTitle.text = @"Thể loại";
    
    
    MenuItem *item = [[MenuItem alloc] init];
    item.title = @"Giải trí";
    item.image = @"theloai_icon_haikich";
    item.image_hover = @"theloai_icon_haikich_hover";
    [self.dataSources addObject:item];
    
    item = [[MenuItem alloc] init];
    item.title = @"Hoạt hình";
    item.image = @"theloai_icon_hoathinh";
    item.image_hover = @"theloai_icon_hoathinh_hover";
    [self.dataSources addObject:item];
    
    item = [[MenuItem alloc] init];
    item.title = @"TV Show";
    item.image = @"theloai_icon_tv-show";
    item.image_hover = @"theloai_icon_tv-show_hover";
    [self.dataSources addObject:item];
    
    item = [[MenuItem alloc] init];
    item.title = @"Phim";
    item.image = @"theloai_icon_phim";
    item.image_hover = @"theloai_icon_phim_hover";
    [self.dataSources addObject:item];
    
    item = [[MenuItem alloc] init];
    item.title = @"Âm nhạc";
    item.image = @"theloai_icon_amnhac";
    item.image_hover = @"theloai_icon_amnhac_hover";
    [self.dataSources addObject:item];
    _tbMain.delegate = self;
    _tbMain.dataSource = self;
    _tbMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbMain.backgroundColor = BACKGROUND_COLOR;
    _tbMain.contentInset = UIEdgeInsetsMake(5, 0, 57, 0);
    _tbMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    self.dataView = _tbMain;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *) tableView:(UITableView *)btableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryCellId =   @"categoryCellId";
    CategoryCell *cell = (CategoryCell*)[btableView dequeueReusableCellWithIdentifier:categoryCellId];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (CategoryCell*) currentObject;
                [cell setValue:categoryCellId forKey:@"reuseIdentifier"];
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    MenuItem *item = [self.dataSources objectAtIndex:indexPath.row];
    cell.lbTitle.text = item.title;
    cell.lbTitle.textColor = RGB(116, 116, 116);
    [cell.imgItem setImage:[UIImage imageNamed:item.image]];
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    [cell.imgBackground setImage:background];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tbMain deselectRowAtIndexPath:indexPath animated:NO];
    BaseVC *controller = nil;
    switch (indexPath.row) {
        case 0:
            controller = [[RelaxVC alloc] initWithNibName:@"RelaxVC" bundle:nil];
            break;
        case 1:
            controller = [[CartoonVC alloc] initWithNibName:@"CartoonVC" bundle:nil];
            break;
        case 2:
            controller = [[TVShowVC alloc] initWithNibName:@"TVShowVC" bundle:nil];
            break;
        case 3:
            controller = [[MovieVC alloc] initWithNibName:@"MovieVC" bundle:nil];
            break;
        case 4:
            controller = [[MusicVC alloc] initWithNibName:@"MusicVC" bundle:nil];
            break;
        default:
            break;
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:_tbMain numberOfRowsInSection:indexPath.section];
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

@end

@implementation MenuItem

@synthesize title;
@synthesize image;
@synthesize image_hover;

@end

