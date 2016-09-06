//
//  RowTable.m
//  NPlus
//
//  Created by Anh Le Duc on 8/1/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "RowTable.h"
#import "Genre.h"
@interface RowTable(){
    NSInteger curIndex;
}
@end
@implementation RowTable
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withData:(NSArray *)data withSection:(NSString*)key{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _dataSource = [[NSMutableArray alloc] initWithArray:data];
        _title = title;
        _key = key;
        curIndex = 100;
        [self setup];
    }
    return self;
}
- (void)setup{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.tag = 10;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    [self addSubview:scrollView];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    sep.backgroundColor = RGB(231, 231, 231);
    [self addSubview:sep];
    self.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

- (void)loadData{
    UIScrollView *scrollView = (UIScrollView*)[self viewWithTag:10];
    int dX = 5;
    int contentWidth = 0;
    if (_title && _title.length > 0) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:_title forState:UIControlStateNormal];
        [button setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        [button setTitleColor:RGB(68, 68, 68) forState:UIControlStateHighlighted];
        [button setTitleColor:RGB(68, 68, 68) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [button sizeToFit];
        CGRect frame = button.frame;
        frame.origin.x = 0;
        frame.size.width += 10;
        frame.origin.y = 0;
        frame.size.height = self.frame.size.height;
        button.frame = frame;
        [scrollView addSubview:button];
        contentWidth += frame.size.width;
        dX += frame.size.width;
    }
    for (int i = 0; i < _dataSource.count; i++) {
        Genre *item = [_dataSource objectAtIndex:i];
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:item.genreName forState:UIControlStateNormal];
        [button setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius  = 5.0f;
        if (i == 0) {
            button.backgroundColor = COLOR_MAIN_BLUE;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        button.tag = 100 + i;
        [button sizeToFit];
        CGRect frame = button.frame;
        frame.origin.x = dX;
        frame.origin.y = 5;
        frame.size.width += 20;
        frame.size.height = self.frame.size.height - 10;
        button.frame = frame;
        [scrollView addSubview:button];
        contentWidth = contentWidth + frame.size.width;
        dX += frame.size.width;
    }
    [scrollView setContentSize:CGSizeMake(contentWidth+10, self.frame.size.height)];
}

- (void)itemTapped:(UIButton*)button{
    NSInteger index = button.tag;
    if (index == curIndex) {
        return;
    }
    UIScrollView *scrollView = (UIScrollView*)[self viewWithTag:10];
    for (UIView *view in [scrollView subviews]) {
        if (![view isKindOfClass:[UIButton class]]) {
            continue;
        }
        UIButton *btn = (UIButton*)view;
        if (btn.tag == index) {
            btn.backgroundColor = COLOR_MAIN_BLUE;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            curIndex = btn.tag;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rowTable:selected:index:)]) {
        [_delegate rowTable:self selected:nil index:curIndex-100];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
