//
//  ArtistResultController.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/16/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ArtistResultController.h"
#import "GenreTableViewCell.h"

@interface ArtistResultController () {
    NSString *_keyword;
}

@end

@implementation ArtistResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbMain.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tbMain.separatorColor = UIColorFromRGB(0xf0f0f0);
    //[self.tbMain setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tbMain registerNib:[UINib nibWithNibName:@"GenreTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"genreCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self trackScreen:@"iOS.SearchArtist"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GenreTableViewCell *cell = (GenreTableViewCell*)[self.tbMain cellForRowAtIndexPath:indexPath];
    if (cell.artist) {
        [APPDELEGATE didSelectArtistCellWith:cell.artist];
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
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        if(self.isLoadMore)
        {
            [self loadMore];
            self.isLoadMore = NO;
        }
    }
}
#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"Nghệ sĩ";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor redColor];
}
@end
