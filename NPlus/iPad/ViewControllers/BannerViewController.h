//
//  iCarouselExampleViewController.h
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iCarousel.h"
#import "CycleScrollView.h"
#import "BannerItemCell.h"

@protocol BannerViewControllerDelegate <NSObject>
- (void) showVideo:(Video*) video;

@end

@interface BannerViewController : UIViewController <CycleScrollViewDelegate>{
    id <BannerViewControllerDelegate> parentDelegate;
    int indexCurrent;
    int totalIndex;
    NSTimer* tmAutoScroll;
    UIPageControl *_pageControl;
    IBOutlet UIView* _showCaseView;
    IBOutlet UIView* _tagsContent;
    NSArray* arrTopKeys;
}

@property (nonatomic, strong) IBOutlet CycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray* listShowcases;
@property (nonatomic, strong) id <BannerViewControllerDelegate> delegate;

- (void) createShowcaseWithList:(NSMutableArray*) list;

@end
