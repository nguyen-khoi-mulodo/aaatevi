//
//  ArtistSuggestVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ArtistSuggestVC.h"
#import "ArtistSuggestItemCell.h"
#import "Artist.h"

@interface ArtistSuggestVC ()

@end

@implementation ArtistSuggestVC

- (void)viewDidLoad {
    self.dataView = gridView;
    [lbTitleArtist setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data
- (void) loadData{
    [self loadArtistsHot];
}

- (void) loadArtistsHot{
    if (self.dataSources.count == 0) {
        self.curPage = kFirstPage;
        [gridView setContentOffset:CGPointZero animated:NO];
        [self showConnectionErrorView:NO];
        [self showNoDataView:NO];
        [self showLoadingDataView:YES];
    }
    
    [[APIController sharedInstance] getListArtistHotWithPageIndex:self.curPage pageSize:kPageSize completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.isLoadMore = loadmore;
            if (self.curPage == kFirstPage) {
                [gridView setContentOffset:CGPointZero animated:NO];
                [self.dataSources removeAllObjects];
//                [self.dataSources addObjectsFromArray:results];
                [self.dataSources addObject:[NSMutableArray arrayWithArray:results]];
                if (self.dataSources.count == 0) {
                    [self showNoDataView:YES];
                }
            }else{
//                [self.dataSources addObjectsFromArray:results];
                [[self.dataSources objectAtIndex:0] addObjectsFromArray:results];
            }
            [self finishLoadData];
            [self showLoadingDataView:NO];
        }else{ // data not exits
            [self.dataSources removeAllObjects];
            [self showLoadingDataView:NO];
            [self finishLoadData];
            [self showNoDataView:YES];
        }
    } failed:^(NSError *error) {
        if (self.dataSources.count == 0) {
            [self showLoadingDataView:NO];
            [self finishLoadData];
            if (APPDELEGATE.internetConnnected) {
                [self showNoDataView:YES];
                [self showConnectionErrorView:NO];
            }else{
                [self showNoDataView:NO];
                [self showConnectionErrorView:YES];
            }
        }
    }];
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 140;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 144;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 2;
}


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

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex andSection:(int) section
{
    ArtistSuggestItemCell *cell = (ArtistSuggestItemCell *)[grid dequeueReusableCell:@"artistSuggestItemCell"];
    if (cell == nil) {
        cell = [[ArtistSuggestItemCell alloc] init];
    }
    
    int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + columnIndex;
    NSMutableArray* arr = [self.dataSources objectAtIndex:section];
    if (arr.count > index) {
        id item = [arr objectAtIndex:index];
        if ([item isKindOfClass:[Artist class]]) {
            Artist* artist = (Artist*)item;
            [cell setContentArtist:artist];
        }
    }
    return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex andSection:(int)section
{
    int index = rowIndex * (int)[grid.uiGridViewDelegate numberOfColumnsOfGridView:grid] + colIndex;
    NSMutableArray* arr = [self.dataSources objectAtIndex:section];
    if (arr.count > index) {
        id item = [arr objectAtIndex: index];
        if([item isKindOfClass:[Artist class]]){
            if (self.delegate && [self.delegate respondsToSelector:@selector(getArtistDetailWithArtist:)]) {
                Artist* artist = (Artist*)item;
                [self.delegate getArtistDetailWithArtist:artist];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [uiGridViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


- (IBAction) cellPressed:(id) sender
{
//    UIGridViewCell *cell = (UIGridViewCell *) sender;
//    [uiGridViewDelegate gridView:self didSelectRowAt:cell.rowIndex AndColumnAt:cell.colIndex];
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
