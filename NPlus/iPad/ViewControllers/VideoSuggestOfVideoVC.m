//
//  ArtistSuggestVC.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "VideoSuggestOfVideoVC.h"
#import "ChannelRelatedItemCell.h"


@interface VideoSuggestOfVideoVC ()

@end

@implementation VideoSuggestOfVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView = [[VideosSuggestTableView alloc] init];
    [myTableView setFrame:CGRectMake(0, 50, myTableView.frame.size.width, myTableView.frame.size.height)];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [self.view addSubview:myTableView];
    self.listVideos = [[NSMutableArray alloc] init];
    [lbTitle setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data

- (void) loadVideosSuggestFromVideoId:(NSString*) videoId{
    [[APIController sharedInstance] getVideoSuggestionWithKey:videoId pageIndex:1 pageSize:10 completed:^(int code ,NSArray *results, BOOL loadmore, int total) {
        if (results) {
            self.listVideos = [NSMutableArray arrayWithArray:results];
            [myTableView reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 226;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"channelRelatedItemCell";
    ChannelRelatedItemCell *cell = (ChannelRelatedItemCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelRelatedItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell commonInit];
    if (indexPath.row < self.listVideos.count) {
        Video* video = [self.listVideos objectAtIndex:indexPath.row];
        [cell setContent:video];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
//    if (indexPath.row < self.listChannels.count) {
//        Channel* channel = [self.listChannels objectAtIndex:indexPath.row];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(showChannel:)]) {
//            [self.delegate showChannel:channel];
//        }
//    }
}

- (IBAction) doShowMore:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideosSuggestMore)]) {
        [self.delegate showVideosSuggestMore];
    }
}

@end
