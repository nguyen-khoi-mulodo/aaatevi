//
//  ArtistSuggestVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "VideosOfSeasonVC.h"
#import "VideoOfSeasonItemCell.h"


@interface VideosOfSeasonVC ()

@end

@implementation VideosOfSeasonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView = [[VideoOfSeasonTableView alloc] init];
    [myTableView setFrame:CGRectMake(lbHeader.frame.size.width, 0, myTableView.frame.size.width - lbHeader.frame.size.width - btnMore.frame.size.width, 60)];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [self.view addSubview:myTableView];
    
    self.listVideos = [[NSMutableArray alloc] init];
    [lbHeader setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data

- (void) loadVideosOfSeasonFromSeasonId:(NSString*) seasonId{
    [[APIController sharedInstance] getSeasonDetailWithKey:seasonId completed:^(int code, Season* seasonFull) {
        self.listVideos = [NSMutableArray arrayWithArray:seasonFull.videos];
        [myTableView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
}

#pragma TableView Delegate

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
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listVideos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"videoOfSeasonIdentifier";
    VideoOfSeasonItemCell *cell = (VideoOfSeasonItemCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoOfSeasonItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell commonInit];
    if (indexPath.row < self.listVideos.count) {
        Video* video = [self.listVideos objectAtIndex:indexPath.row];
        [cell setContent:video];
    }
    return cell;
}

- (IBAction) doShowMore:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideosOfSeason:)]) {
        [self.delegate showVideosOfSeason:self.listVideos];
    }
}

//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
//    if (indexPath.row < self.listChannels.count) {
//        Channel* channel = [self.listChannels objectAtIndex:indexPath.row];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(showChannel:)]) {
//            [self.delegate showChannel:channel];
//        }
//    }
//}

@end
