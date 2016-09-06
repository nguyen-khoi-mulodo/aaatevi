//
//  ArtistDetail_iPad.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/15/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ArtistDetail_iPad.h"
#import "UIImageEffects.h"
#import "ArtistChannel_iPad.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ArtistDetail_iPad ()<ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic) NSUInteger numberOfTabs;
@end


@implementation ArtistDetail_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.infoView setBackgroundColor:[UIColor clearColor]];
    
    self.dataSource = self;
    self.delegate = self;
    _numberOfTabs = 2;
    
    [lbAlias setFont:[UIFont fontWithName:kFontSemibold size:19.0f]];
    [lbName setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbBirthDay setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbGender setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbNational setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbTitleName setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbTitleBirthDay setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbTitleGender setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
    [lbTitleNational setFont:[UIFont fontWithName:kFontRegular size:17.0f]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data

- (void) loadDataWithArtist:(Artist*) artist{
    self.mArtist = artist;
    [artistBannerView setImage:[UIImageEffects imageByApplyingLightEffectToImage:[UIImage imageNamed:@"default-dienvien-ipad"]]];
    [artistBannerView setClipsToBounds:YES];
    
    _artistImageView.layer.cornerRadius = 75.0f;
    _artistImageView.layer.borderWidth = 2.0f;
    [_artistImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_artistImageView setClipsToBounds:YES];
    [_artistImageView setImageWithURL:[NSURL URLWithString:artist.avatarImg] placeholderImage:[UIImage imageNamed:@"default-dienvien-ipad"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [artistBannerView setImage:[UIImageEffects imageByApplyingLightEffectToImage:image]];
    }];
    
    NSString* alias = artist.alias;
    if ([artist.alias isEqualToString:@""] || !artist.alias) {
        alias = artist.name;
    }
    [lbAlias setText:artist.name];
    [lbName setText:artist.name];
    [lbBirthDay setText:artist.birthday];
    [lbNational setText:artist.national];
    [lbGender setText:artist.gender];
    
    if (artistInfo) {
        [artistInfo loadDataWithArtist:self.mArtist];
    }
    
    if (artistChannel) {
        [artistChannel loadDataWithArtist:self.mArtist];
    }
    
//    [self selectTabAtIndex:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    switch (index) {
        case 0:
            label.text = @"Thông Tin";
            break;
        case 1:
            label.text = @"Kênh";
            break;
        default:
            break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x212121);
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            if (!artistInfo) {
                artistInfo = [[ArtistInfoDetailVC_iPad alloc] initWithNibName:@"ArtistInfoDetailVC_iPad" bundle:nil];
            }
            return artistInfo;
            break;
        case 1:
            if (!artistChannel) {
                artistChannel = [[ArtistChannel_iPad alloc] initWithNibName:@"ArtistChannel_iPad" bundle:nil];
            }
            [artistChannel setDelegate:self];
            [artistChannel loadDataWithArtist:self.mArtist];
            return artistChannel;
            break;
        default:
            break;
    }
    return nil;
}


#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 50.0;
        case ViewPagerOptionTabOffset:
            return self.infoView.frame.size.height;
        case ViewPagerOptionTabWidth:
            return 337.0f;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return kSelectedColor;
        case ViewPagerContent:
            return [UIColor clearColor];
        case ViewPagerTabsView:
//            return kMenuBackground;
            return UIColorFromRGB(0xfcfcfc);
        default:
            return color;
    }
}

- (void) showChannel:(id)item{
    if (self.artistDelegate && [self.artistDelegate respondsToSelector:@selector(showChannel:)]) {
        [self.artistDelegate showChannel:item];
    }
}

@end
