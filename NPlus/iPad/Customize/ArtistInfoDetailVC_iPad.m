//
//  VideoDetailVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 2/22/16.
//  Copyright © 2016 thienvc. All rights reserved.
//

#import "ArtistInfoDetailVC_iPad.h"
#import "Util.h"
#import "Artist.h"
#import "ArtistSuggestItemCell.h"
//#import "CustomTagsView.h"

#define NUM_COLUMS_ARTIST 4
#define GRIDVIEW_HEIGH 149

@interface ArtistInfoDetailVC_iPad (){
    float heightDesInfo;
    BOOL isExpanded;
}
@end

@implementation ArtistInfoDetailVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    [myTableView setTableFooterView:view];
    isExpanded = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Load Data
- (void) loadDataWithArtist:(Artist *)artist{
    self.mArtist = artist;
    [myTableView setContentOffset:CGPointZero animated:NO];
    [myTableView reloadData];
}



#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
//        heightDesInfo = [Util heightForCellWithContent:self.mArtist.fullDes withFont:[UIFont fontWithName:kFontRegular size:15.0f]] + 42;
//        if (!isExpanded) {
//            heightDesInfo = heightDesInfo > 145 ? 145 : heightDesInfo;
//        }
//        return heightDesInfo;
        return 424;
    }else if(indexPath.row == 1){
        return 318;
    }
    return 318;
}

#pragma mark - Custom Cell

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self tableView:tableView cellDesAtIndexPath:indexPath];
    }else if (indexPath.row == 1){
        return [self tableView:tableView commentCellForRowAtIndexPath:indexPath];
    }
    return [self tableView:tableView commentCellForRowAtIndexPath:indexPath];
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
}

- (ArtistDescriptionItemCell*)tableView:(UITableView*)tableView cellDesAtIndexPath:(NSIndexPath*)indexPath {
    ArtistDescriptionItemCell *cell = (ArtistDescriptionItemCell*)[tableView dequeueReusableCellWithIdentifier:@"artistDescriptionItemCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ArtistDescriptionItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
//    cell.tvDesc.text = self.mArtist.fullDes;
    [cell setContent:self.mArtist.fullDes];
//    if (!isExpanded) {
//        cell.tvDesc.frame = cell.tvDesc.bounds;
//        [cell.contentView layoutIfNeeded] ;
//    }
    cell.tvDesc.frame = cell.tvDesc.bounds;
    [cell.contentView layoutIfNeeded] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (CommentItemCell*)tableView:(UITableView*)tableView commentCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    CommentItemCell *cell = (CommentItemCell*)[tableView dequeueReusableCellWithIdentifier:@"commentItemCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void) doShowMore{
    [self updateTableView];
}

- (void)updateTableView
{
    isExpanded = !isExpanded;
    [myTableView beginUpdates];
    [myTableView endUpdates];
    
}

@end
