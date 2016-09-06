//
//  ArtistSuggestVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "SeasonsOfChannelVC.h"
#import "ArtistSuggestItemCell.h"
#import "Artist.h"
#import "SeasonItemCell.h"


@interface SeasonsOfChannelVC ()

@end

@implementation SeasonsOfChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [myTableView setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    [lbTitlePlaylist setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
}

#pragma mark Load Data

- (void) loadDataWithChannel:(Channel*) channel{
    self.mChannel = channel;
    self.dataSources = [NSMutableArray arrayWithArray:channel.seasons];
    [myTableView setScrollEnabled:(self.mChannel.seasons.count > 3)];
    [myTableView setContentOffset:CGPointZero];
    [myTableView reloadData];
}


#pragma mark TableView Delegate

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
    return self.dataSources.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"seasonItemCell";
    SeasonItemCell *cell = (SeasonItemCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SeasonItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row < self.dataSources.count) {
        Season* season = [self.dataSources objectAtIndex:indexPath.row];
        [cell setContentWithSeason:season];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (indexPath.row < self.dataSources.count) {
        Season* season = [self.dataSources objectAtIndex:indexPath.row];
        season.channel = self.mChannel;
        if (self.delegate && [self.delegate respondsToSelector:@selector(showVideo:)]) {
            [self.delegate showVideo:season];
        }
    }
}

@end
