#import <UIKit/UIKit.h>
@protocol CycleScrollViewDelegate;
@interface CycleScrollView : UIView
@property (nonatomic , strong) id<CycleScrollViewDelegate> delegate;
@property (nonatomic , readonly) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;
- (void)cycleScrollPause;
- (void)cycleScrollResume;
- (void) setAnimationDuration:(NSTimeInterval)animationDuration;
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);

@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);

@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@end

@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollView:(CycleScrollView*)cycleScroll scrollAtIndex:(NSInteger)pageIndex;
- (void)cycleScrollView:(CycleScrollView*)cycleScroll tapAtIndex:(NSInteger)pageIndex;
@end