

#import "VideosSuggestTableView.h"
#import "APIController.h"
#import "Channel.h"
#import "ChannelRelatedItemCell.h"

@implementation VideosSuggestTableView

- (id) init {
    if (self = [super init]) {
        [self setFrame:CGRectMake(0, 0, 172, 674)];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setRowHeight:172];
        [self setCenter:CGPointMake(674 / 2, 172 / 2)];
        self.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
@end
