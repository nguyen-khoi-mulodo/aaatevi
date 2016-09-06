

#import "VideoOfSeasonTableView.h"

@implementation VideoOfSeasonTableView

- (id) init {
    if (self = [super init]) {
        [self setFrame:CGRectMake(0, 0, 60, 674)];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setRowHeight:60];
        [self setCenter:CGPointMake(674 / 2, 60 / 2)];
        self.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self setBackgroundColor:[UIColor clearColor]];
//        self.scrollEnabled = NO;
        
    }
    return self;
}


@end
