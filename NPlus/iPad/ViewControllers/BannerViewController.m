//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "BannerViewController.h"
#import "FXImageView.h"
#import "Showcase.h"

@implementation BannerViewController

#pragma mark -
#pragma mark View lifecycle

- (void)setUp
{
    //set up data
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _listShowcases = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
    
    _cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 748, 245) animationDuration:5];
    _cycleScrollView.backgroundColor = UIColorFromRGB(0xfcfcfc);
    _cycleScrollView.delegate = self;
    [_showCaseView addSubview:_cycleScrollView];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(289, 207, 172, 37)];
    [_showCaseView addSubview:_pageControl];

    if ([_pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
    {
        [_pageControl setCurrentPageIndicatorTintColor:COLOR_MAIN_BLUE];
    }
    if ([_pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)])
    {
        [_pageControl setPageIndicatorTintColor: [UIColor colorWithWhite:1.0f alpha:0.5f]];
    }
    
    [self getDiscoveryData];

}

- (void) getDiscoveryData {
    if (APPDELEGATE.internetConnnected) {
//        [loadingTopKeys startAnimating];
        [[APIController sharedInstance] getTopKeyWordsCompleted:^(int code, NSArray *results) {
            if (code == kAPI_SUCCESS) {
                arrTopKeys = results;
                [self initTagsView];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}

- (void) createShowcaseWithList:(NSMutableArray*) list {
    if (list.count > 0)
    {
        NSMutableArray *data = list;
        NSMutableArray *viewsArray = [@[] mutableCopy];
        for (int i = 0; i < data.count; i++)
        {
            CGRect frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            frame.size.width = _cycleScrollView.frame.size.width;
            frame.size.height = _cycleScrollView.frame.size.height;
            
            UIView *view = [[UIView alloc] initWithFrame:frame];
            id obj = [data objectAtIndex:i];
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            imageview.contentMode = UIViewContentModeScaleAspectFill;
            if ([obj isKindOfClass:[Showcase class]])
            {
                Showcase *item = (Showcase *) obj;
                [imageview setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"default_showcase"]];
            }
            [view addSubview:imageview];
            [viewsArray addObject:view];
        }
        _cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        _cycleScrollView.totalPagesCount = ^NSInteger(void){
            return viewsArray.count;
        };
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = viewsArray.count;
    }
}

- (void) initTagsView{
    if (_tagsContent.subviews.count > 0) {
        for (UIView* v in _tagsContent.subviews) {
            if (v.tag != 1000 && v.tag != 1001) {
                [v removeFromSuperview];
            }
        }
    }
    
    if (arrTopKeys.count > 0) {
        int col = 2;
        int row = 3;
        float dX = 12;
        float dY = 25;
        float width = _tagsContent.frame.size.width;
        float height = _tagsContent.frame.size.height;
        float W = (width - dX * (col + 1)) / col;
        float H = (height - dY * (row - 1)) / row;
        int index = 0;
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(dX * (j + 1) + W * j, dY * i + H * i, W, H)];
                [btn.layer setBorderColor:[UIColorFromRGB(0x00adef) CGColor]];
                [btn.layer setBorderWidth:1.0f];
                [btn.layer setCornerRadius:5.0f];
                [btn setClipsToBounds:YES];
                [btn.titleLabel setFont:[UIFont fontWithName:kFontRegular size:15.0]];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:UIColorFromRGB(0x00adef) forState:UIControlStateNormal];
                [btn setBackgroundColor:UIColorFromRGB(0xfcfcfc)];
                index = i * col + j;
                [btn setTag:index];
//                [btn addTarget:self action:@selector(doSelectWithKey:) forControlEvents:UIControlEventTouchUpInside];
                TopKeyword* keyword = [arrTopKeys objectAtIndex:index];
                [btn setTitle:keyword.title forState:UIControlStateNormal];
                btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
                [_tagsContent addSubview:btn];
            }
        }
//        [loadingTopKeys stopAnimating];
    }
}


//- (void) autoChangeShowCase:(NSTimer *)theTimer{
//    indexCurrent++;
//    if (indexCurrent == list.count) {
//        indexCurrent = 0;
//    }
//    [carousel scrollToItemAtIndex:indexCurrent animated:YES];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



//#pragma mark -
//#pragma mark UIActionSheet methods

//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex >= 0)
//    {
//        //map button index to carousel type
//        iCarouselType type = buttonIndex;
//        
//        //carousel can smoothly animate between types
//        [UIView beginAnimations:nil context:nil];
//        carousel.type = type;
//        [UIView commitAnimations];
//        
//        //update title
//    }
//}
//
//#pragma mark -
//#pragma mark iCarousel methods
//
//- (NSUInteger) numberOfItemsInCarousel:(iCarousel *)carousel
//{
//    return list.count;
//}

//- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
//{
//	UIImageView *imageView = (UIImageView *)view;
//	if (imageView == nil)
//	{
//		//no button available to recycle, so create new one
//		UIImage *image = [UIImage imageNamed:@"page.png"];
//        imageView = [[UIImageView alloc] initWithImage:image];
//		imageView.frame = CGRectMake(self.carousel.frame.origin.x, self.carousel.frame.origin.y, 496, 200);
//        [imageView setContentMode:UIViewContentModeScaleAspectFill];
//        imageView.layer.cornerRadius = 5.0f;
//        imageView.layer.masksToBounds = YES;
//	}
//	
//    if (list.count > 0) {
//        ShowCase* showCase = [list objectAtIndex:index];
//        [imageView setImageWithURL:[NSURL URLWithString:showCase.imageUrl] placeholderImage:[UIImage imageNamed:@"default_showcase"]];
////        MAKESHADOW(imageView);
//    }
//	return imageView;
//}

//- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
//{
//    //create new view if no view is available for recycling
//    BannerItemCell* bannerItemView = (BannerItemCell*)view;
//    if (bannerItemView == nil)
//    {
//        bannerItemView = [[BannerItemCell alloc] init];
//    }
//    Video* video = [list objectAtIndex:(int)index];
//    [bannerItemView setContentVideo:video];
//    return bannerItemView;
//}
//
//
//- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
//{
//    //implement 'flip3D' style carousel
//    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
//    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
//}
//
//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
//{
//    switch (option)
//    {
//        case iCarouselOptionFadeMin:
//            return 0.0;
////            return 0.0;
//        case iCarouselOptionFadeMax:
//            return 0.0;
//        case iCarouselOptionFadeRange:
//            return 2.0;
//        case iCarouselOptionAngle:
//            return value * 0.4;
//        case iCarouselOptionSpacing:
//            return value * 1.75;
//        default:
//            return value;
//    }
//}
//
//#pragma mark -
//#pragma mark iCarousel taps
//
//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
//{
//    if (index < list.count) {
//        Video* video = [list objectAtIndex:index];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(showVideo:)]) {
//            [self.delegate showVideo:video];
//        }
//    }
//    
//}
//
//- (void)carouselCurrentItemIndexDidChange:(iCarousel *)iCarousel{
//    indexCurrent = (int)iCarousel.currentItemIndex;
//    int indexBefore = indexCurrent - 1;
//    if (indexBefore == -1) {
//        indexBefore = 4;
//    }
//    BannerItemCell* beforeView = (BannerItemCell*)[iCarousel itemViewAtIndex:indexBefore];
//    [beforeView showButtonPlay:NO];
//    
////    NSLog(@"%d", indexCurrent);
//    BannerItemCell* currentView = (BannerItemCell*)[iCarousel itemViewAtIndex:indexCurrent];
//    [currentView showButtonPlay:YES];
//}
//
//- (void)carouselWillBeginDragging:(iCarousel *)carousel{
//    [tmAutoScroll invalidate];
//}
//
//- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
//    tmAutoScroll=[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(autoChangeShowCase:) userInfo:nil repeats:YES];
//}

#pragma mark - CycleScrollView Delegate
- (void)cycleScrollView:(CycleScrollView *)cycleScroll scrollAtIndex:(NSInteger)pageIndex{
    _pageControl.currentPage = pageIndex;
}
- (void)cycleScrollView:(CycleScrollView *)cycleScroll tapAtIndex:(NSInteger)pageIndex {
//    [self trackEvent:@"iOS_showcase"];
    NSArray *arrayShowcase = self.listShowcases;
    if (pageIndex > arrayShowcase.count) {
        return;
    }
//    Showcase *sc = (Showcase*)[arrayShowcase objectAtIndex:pageIndex];
//    if ([sc.type isEqualToString:@"video"]) {
//        Video *v = [[Video alloc]init];
//        v.video_id = sc.itemKey;
//        [APPDELEGATE didSelectVideoCellWith:v];
//    } else if ([sc.type isEqualToString:@"channel"]) {
//        Channel *c = [[Channel alloc]init];
//        c.channelId = sc.itemKey;
//        [APPDELEGATE didSelectChannelCellWith:c];
//    }
}

@end
