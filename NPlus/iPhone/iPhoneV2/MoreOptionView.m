//
//  MoreOptionView.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 2/17/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "MoreOptionView.h"
#import "MoreOptionButton.h"

@implementation MoreOptionView

- (id)initWithFrame:(CGRect)frame type:(int)type object:(id)objectKey linkShare:(NSString *)linkShare{
    self = [super initWithFrame:frame];
    if (self) {
        _objectKey = objectKey;
        _type = type;
        if (linkShare) {
            _linkShare = linkShare;
        }
        UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        view = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*3)];
        originFrame = view.frame;
        if (type == 5) {
            MoreOptionButton *btn1 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-share-popup-v2" iconSelected:@"icon-share-popup-h-v2" title:@"Chia sẻ Facebook"];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
            MoreOptionButton *btn2 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-copylink-popup-v2" iconSelected:@"icon-copylink-popup-h-v2" title:@"Copy Link"];
            btn2.tag = 2;
            [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn2];

        } else if (type == 4) {
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow)];
            btn1.backgroundColor = [UIColor whiteColor];
            UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, view.frame.size.width - 20, kHeightMoreOptionRow)];
            lbl1.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            lbl1.text = @"Chất lượng thường";
            lbl1.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:17];
            [btn1 addSubview:lbl1];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow)];
            btn2.backgroundColor = [UIColor whiteColor];
            UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, view.frame.size.width - 20, kHeightMoreOptionRow)];
            lbl2.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            lbl2.text = @"Chất lượng cao";
            lbl2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:17];
            [btn2 addSubview:lbl2];
            btn2.tag = 2;
            [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn2];
        } else if (type == 3) {
            view.frame = CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*4);
            originFrame = view.frame;
            
            MoreOptionButton *btn1 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-share-popup-v2" iconSelected:@"icon-share-popup-h-v2" title:@"Chia sẻ Facebook"];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
            MoreOptionButton *btn2 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-copylink-popup-v2" iconSelected:@"icon-copylink-popup-h-v2" title:@"Copy Link"];
            btn2.tag = 2;
            [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn2];
            
            MoreOptionButton *btn3 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow*2, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-botheodoi-popup-v2" iconSelected:@"icon-botheodoi-popup-h-v2" title:@"Bỏ theo dõi"];
            btn3.tag = 3;
            [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn3];
            
        } else {
            
            if (type == 1) {
                view.frame = CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*4);
                originFrame = view.frame;
                
                MoreOptionButton *btn1 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-share-popup-v2" iconSelected:@"icon-share-popup-h-v2" title:@"Chia sẻ Facebook"];
                btn1.tag = 1;
                [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn1];
                
                MoreOptionButton *btn2 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-copylink-popup-v2" iconSelected:@"icon-copylink-popup-h-v2" title:@"Copy Link"];
                btn2.tag = 2;
                [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn2];
                
                MoreOptionButton *btn3 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow*2, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-boxemsau-popup-v2" iconSelected:@"icon-boxemsau-popup-h-v2" title:@"Bỏ xem sau"];
                btn3.tag = 3;
                [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn3];
            } else if (type == 2){
                view.frame = CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*2);
                originFrame = view.frame;
                
                UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow)];
                btn2.backgroundColor = [UIColor whiteColor];
                UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 25, 25)];
                img2.image = [UIImage imageNamed:@"icon-xoa"];
                UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, view.frame.size.width - 60, kHeightMoreOptionRow)];
                lbl2.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
                lbl2.text = @"Xóa";
                lbl2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:17];
                [btn2 addSubview:img2];
                [btn2 addSubview:lbl2];
                btn2.tag = 1;
                [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:btn2];
            }
        }
        MoreOptionButton *btn3 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow*2, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-huy-popup-v2" iconSelected:@"icon-huy-popup-h-v2" title:@"Hủy"];
        btn3.tag = 3;
        [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn3];
        if (type == 2) {
            btn3.frame = CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow);
        } else if (type == 3 || type == 1) {
            btn3.frame = CGRectMake(0, kHeightMoreOptionRow*3, frame.size.width, kHeightMoreOptionRow);
            btn3.tag = 4;
        }
        [self addSubview:view];
        APPDELEGATE.isShowingPopup = YES;
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(0, frame.size.height - view.frame.size.height, frame.size.width, view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(int)type object:(id)object linkShare:(NSString *)linkShare numOfItem:(int)numOfItem arrayTitle:(NSArray*)arrayTitle{
    self = [super initWithFrame:frame];
    if (self) {
        _objectKey = object;
        _type = type;
        if (linkShare) {
            _linkShare = linkShare;
        }
        UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        view = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*(numOfItem+1))];
        originFrame = view.frame;
        if (type == 6) {
            
            for (int i = 0; i < numOfItem; i++) {
                MoreOptionButton *btn1 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow*i, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-select-v2" iconSelected:@"icon-selected-v2" title:[arrayTitle objectAtIndex:i]];
                btn1.tag = i;
                [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn1];
            }
            
        } else if (type == 5) {
            MoreOptionButton *btn1 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-share-popup-v2" iconSelected:@"icon-share-popup-h-v2" title:@"Chia sẻ Facebook"];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
            MoreOptionButton *btn2 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-copylink-popup-v2" iconSelected:@"icon-copylink-popup-h-v2" title:@"Copy Link"];
            btn2.tag = 2;
            [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn2];
            
        } else if (type == 4) {
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow)];
            btn1.backgroundColor = [UIColor whiteColor];
            UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, view.frame.size.width - 20, kHeightMoreOptionRow)];
            lbl1.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            lbl1.text = @"Chất lượng thường";
            lbl1.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:17];
            [btn1 addSubview:lbl1];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow)];
            btn2.backgroundColor = [UIColor whiteColor];
            UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, view.frame.size.width - 20, kHeightMoreOptionRow)];
            lbl2.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            lbl2.text = @"Chất lượng cao";
            lbl2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:17];
            [btn2 addSubview:lbl2];
            btn2.tag = 2;
            [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn2];
        } else if (type == 3) {
            view.frame = CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*3);
            originFrame = view.frame;
            
            MoreOptionButton *btn1 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-share-popup-v2" iconSelected:@"icon-share-popup-h-v2" title:@"Chia sẻ Facebook"];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
            
            MoreOptionButton *btn2 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-boxemsau-popup-v2" iconSelected:@"icon-boxemsau-popup-h-v2" title:@"Bỏ xem sau"];
            btn2.tag = 2;
            [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn2];
            
        } else {
            
            if (type == 1) {
                view.frame = CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*3);
                originFrame = view.frame;
                
                MoreOptionButton *btn1 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-share-popup-v2" iconSelected:@"icon-share-popup-h-v2" title:@"Chia sẻ Facebook"];
                btn1.tag = 1;
                [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn1];
                
                MoreOptionButton *btn2 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-boxemsau-popup-v2" iconSelected:@"icon-boxemsau-popup-h-v2" title:@"Bỏ theo dõi"];
                btn2.tag = 2;
                [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn2];
            } else if (type == 2){
                view.frame = CGRectMake(0, frame.size.height, frame.size.width, kHeightMoreOptionRow*2);
                originFrame = view.frame;
                
                UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kHeightMoreOptionRow)];
                btn2.backgroundColor = [UIColor whiteColor];
                UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 25, 25)];
                img2.image = [UIImage imageNamed:@"icon-xoa"];
                UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, view.frame.size.width - 60, kHeightMoreOptionRow)];
                lbl2.textColor = [UIColor colorWithWhite:0.0 alpha:0.7];
                lbl2.text = @"Xóa";
                lbl2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:17];
                [btn2 addSubview:img2];
                [btn2 addSubview:lbl2];
                btn2.tag = 1;
                [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:btn2];
            }
        }
        MoreOptionButton *btn3 = [[MoreOptionButton alloc]initWithFrame:CGRectMake(0, kHeightMoreOptionRow*numOfItem, frame.size.width, kHeightMoreOptionRow) iconDefault:@"icon-huy-popup-v2" iconSelected:@"icon-huy-popup-h-v2" title:@"Hủy"];
        btn3.tag = numOfItem;
        [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn3];
        [self addSubview:view];
        APPDELEGATE.isShowingPopup = YES;
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(0, frame.size.height - view.frame.size.height, frame.size.width, view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    return self;
}

- (void)btnAction:(id)sender {
    MoreOptionButton *button = (MoreOptionButton*)sender;
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = originFrame;
    } completion:^(BOOL finished) {
        APPDELEGATE.isShowingPopup = NO;
        [self removeFromSuperview];
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(didTappedButtonIndex:object:linkShare:title:)]) {
        [_delegate didTappedButtonIndex:(int)button.tag object:_objectKey linkShare:_linkShare title:button.lblTitle.text];
    }
}

- (void)cancelAction {
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = originFrame;
    } completion:^(BOOL finished) {
        APPDELEGATE.isShowingPopup = NO;
        [self removeFromSuperview];
    }];
}

- (void)tapGesture {
    [self cancelAction];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
