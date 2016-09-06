//
//  SubListVideoVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "HistoryVC_iPad.h"
#import "DBHelper.h"
#import "HistoryItemCell.h"

@interface HistoryVC_iPad ()

@end

@implementation HistoryVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [gridView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
    [gridView setBackgroundColor:[UIColor clearColor]];
    self.dataView = gridView;
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,0.0f - gridView.frame.size.height, self.view.frame.size.width, gridView.frame.size.height)];
        view.delegate = self;
        [gridView addSubview:view];
        _refreshHeaderView = view;
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kLoadListChannelLiked object:nil];
    
    [lbNodata setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    
    [btnCancel.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [btnDelete.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
    [btnChoose.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [gridView setContentOffset:CGPointZero];
//    [self setScreenName:@"iPad.CuaTui"];
}

#pragma mark -
#pragma mark Load Data

- (void) loadData{
//    [self loadListChannelLikedWithPageIndex:self.curPage pageSize:kPageSize];
    [self.dataSources removeAllObjects];
    [self.dataSources addObject:[NSMutableArray arrayWithArray:[[DBHelper sharedInstance]getVideoHistory]]];
    [self finishLoadData];
}

- (void) showNoDataView: (BOOL) show
{
    if (self.noDataView == nil) {
        if (IS_IPAD) {
            self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }else{
            self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height)];
        }
        self.noDataView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:self.noDataView atIndex:0];
        [vNoData setCenter:self.noDataView.center];
        [vNoData setTag:1000];
        [self.noDataView addSubview:vNoData];
        [vNoData setHidden:NO];
    }
    else{
        float bottomHeight = 60;
        float topHeight =(self.view.frame.origin.y > 0) ? 0 : (287 + 60);
        [self.noDataView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight - topHeight)];
        UIView* subView = [self.noDataView viewWithTag:1000];
        [subView setCenter:self.noDataView.center];
    }
    
    self.dataView.hidden = show;
    self.noDataView.hidden = !show;
}

- (void) logout{
    [self showNoDataView:NO];
}

- (void) shareFacebookWithItem:(id) item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareFacebookWithItem:)]) {
        [self.delegate shareFacebookWithItem:item];
    }
}

#pragma GridView Delegate

- (NSInteger) numberOfSectionsInGridView:(UIGridView *)grid{
    return self.dataSources.count;
}

- (NSInteger) gridView:(UIGridView *)grid numberOfRowsInSection:(NSInteger)section{
    if (self.dataSources.count > section) {
        return [[self.dataSources objectAtIndex:section] count];
    }
    return 0;
}

- (CGFloat) gridView:(UIGridView *)grid heightForHeaderInSection:(int) section{
    return 0;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 3;
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 250;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 208;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex andSection:(int) section
{
    
    static NSString *CellIdentifier1 = @"historyItemCell";
    int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
    NSMutableArray* arr = [self.dataSources objectAtIndex:section];
    if (arr.count > index) {
        HistoryItemCell *cell = (HistoryItemCell *)[grid dequeueReusableCell:CellIdentifier1];
        if (cell == nil) {
            cell = [[HistoryItemCell alloc] init];
        }
        id item = [arr objectAtIndex:index];
        if ([item isKindOfClass:[CDHistory class]]) {
            CDHistory* his = (CDHistory*)item;
            [cell setVideo:his];
        }
        return cell;
    }
    return nil;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    [super doneLoadingTableViewData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:gridView];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
