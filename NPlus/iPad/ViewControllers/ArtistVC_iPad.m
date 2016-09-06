//
//  ArtistVC_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ArtistVC_iPad.h"

@interface ArtistVC_iPad ()

@end

@implementation ArtistVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showArtistDetail];
    [self showArtistSuggest];
    [self.view bringSubviewToFront:self.btnBack];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self getArtistDetailWithArtist:self.mArtist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load UI

- (void) showArtistDetail{
    if (!artistDetailVC) {
        artistDetailVC = [[ArtistDetail_iPad alloc] initWithNibName:@"ArtistDetail_iPad" bundle:nil];
    }
    [artistDetailVC.view setFrame:CGRectMake(0, 0, artistDetailVC.view.frame.size.width, artistDetailVC.view.frame.size.height)];
    [artistDetailVC setArtistDelegate:self];
    [self.view addSubview:artistDetailVC.view];
    [artistDetailVC viewWillAppear:YES];
}

- (void) showArtistSuggest{
    if (!artistSuggestVC) {
        artistSuggestVC = [[ArtistSuggestVC alloc] initWithNibName:@"ArtistSuggestVC" bundle:nil];
    }
    [artistSuggestVC.view setFrame:CGRectMake(artistDetailVC.view.frame.size.width, 0, artistSuggestVC.view.frame.size.width, SCREEN_HEIGHT)];
    [artistSuggestVC setDelegate:self];
    [self.view addSubview:artistSuggestVC.view];
}

- (void) showChannelView{
    
}

//- (void) showVideoSuggest{
//    if (!videoHotVC) {
//        videoHotVC = [[VideoSuggestVC_iPad alloc] initWithNibName:@"VideoSuggestVC_iPad" bundle:nil];
//    }
//    [videoHotVC.view setFrame:CGRectMake(artistDetailVC.view.frame.size.width, artistSuggestVC.view.frame.size.height, videoHotVC.view.frame.size.width, videoHotVC.view.frame.size.height)];
//    [self.view addSubview:videoHotVC.view];
//}

#pragma mark Load Data

- (void) getArtistDetailWithArtist:(Artist*) artist{
    self.mArtist = artist;
    [[APIController sharedInstance] getArtistDetailWithKey:artist.artistId completed:^(int code, Artist* artistFull) {
        self.mArtist = artistFull;
        [artistDetailVC loadDataWithArtist:self.mArtist];
    } failed:^(NSError *error) {
        NSLog(@"fail");
    }];
}

//- (void) showChannel:(id) item{
//    NSLog(@"aaa");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self showMenuAnimation:YES];
}


@end
