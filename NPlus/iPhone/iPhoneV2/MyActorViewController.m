//
//  MyActorViewController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 1/4/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "MyActorViewController.h"
#import "GenreTableViewCell.h"

@interface MyActorViewController () {
    NSString *_keyword;
}

@end

@implementation MyActorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgBG.hidden = NO;
    [self.tbMain setBackgroundColor:[UIColor clearColor]];
    tableViewController.refreshControl.hidden = YES;
    refreshControl.hidden = YES;
    refreshControl.tintColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tbMain setContentOffset:CGPointMake(0, 0)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Process
-(void)loadDataIsAnimation:(BOOL)isAnimation{
    self.pageIndex = 1;
    self.total = 0;
    self.isLoadMore = NO;
    [self.dataSources removeAllObjects];
    [self searchArtistByKeyWord:_keyword isNewSearch:NO];
}

- (void)loadMore {
    if (self.isLoadMore) {
        [self searchArtistByKeyWord:_keyword isNewSearch:NO];
    }
}
- (void)searchArtistByKeyWord:(NSString*)keyword isNewSearch:(BOOL)isNewSearch{
    _keyword = keyword;
    if (isNewSearch) {
        self.total = 0;
        self.pageIndex = 1;
    }
    if (APPDELEGATE.internetConnnected) {
        //[Utilities showGlobalProgressHUDWithTitle:nil];
        [[APIController sharedInstance]searchArtistByKeyword:keyword pageIndex:self.pageIndex pageSize:kDefaultPageSize completed:^(int code, NSArray *results, BOOL loadmore, int total) {
            if (results) {
                NSArray *array = results;
                if (isNewSearch) {
                    self.dataSources = (NSMutableArray*)array;
                } else {
                    [self.dataSources addObjectsFromArray:array];
                }
                self.isLoadMore = loadmore;
                if (loadmore) {
                    self.pageIndex = self.pageIndex + 1;
                }
                [self.tbMain reloadData];
            }
            [Utilities dismissGlobalHUD];
            [self loadEmptyData];
        } failed:^(NSError *error) {
            [Utilities dismissGlobalHUD];
        }];
    } else {
        
    }
}


#pragma mark UITableView delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 4;
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *) tableView:(UITableView *)btableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *genreCell = @"genreCell";
    GenreTableViewCell *cell = (GenreTableViewCell*)[self.tbMain dequeueReusableCellWithIdentifier:genreCell];
    if (!cell) {
        cell = [Utilities loadView:[GenreTableViewCell class] FromNib:@"GenreTableViewCell"];
    }
    if (self.dataSources.count > indexPath.row) {
        Artist *artist = (Artist*)[self.dataSources objectAtIndex:indexPath.row];
        cell.artist = artist;
        [cell loadContentViewArtist];
    }
    [cell.contentView setBackgroundColor:RGBA(34, 46, 51, 0.4)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GenreTableViewCell *cell = (GenreTableViewCell*)[self.tbMain cellForRowAtIndexPath:indexPath];
    if (cell.artist) {
    
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffsetY = scrollView.contentOffset.y;
    if(scrollOffsetY < 0)
    {

    } else if (scrollOffsetY > 0){
        if (self.homeDelgate && [self.homeDelgate respondsToSelector:@selector(scrollToTop:)]) {
            [self.homeDelgate scrollToTop:self.scrollToTop];
        }
    }
    
    if (self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0)
    {
        if (self.scrollToTop) {
            if (self.homeDelgate && [self.homeDelgate respondsToSelector:@selector(scrollToTop:)]) {
                [self.homeDelgate scrollToTop:self.scrollToTop];
            }
        }
    }
    self.lastContentOffset = scrollView.contentOffset.y;
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if(self.isLoadMore)
        {
            [self loadMore];
            self.isLoadMore = NO;
        }
    }
    
}
- (BOOL)shouldAutorotate {
    return NO;
}
@end
