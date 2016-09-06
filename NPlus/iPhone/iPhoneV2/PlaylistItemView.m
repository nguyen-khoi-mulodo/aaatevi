//
//  PlaylistItemView.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/5/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "PlaylistItemView.h"

@implementation PlaylistItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, frame.size.width - 20, 40)];
        titleView.backgroundColor = [UIColor clearColor];
        
        _lblPlaylistName = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, frame.size.width - 20, 40)];
        _lblPlaylistName.font = [UIFont fontWithName:kFontRegular size:15];
        _lblPlaylistName.numberOfLines = 0;
        _lblPlaylistName.lineBreakMode = NSLineBreakByWordWrapping;
        [titleView addSubview:_lblPlaylistName];
        
        _lblNumOfVideo = [[UILabel alloc]initWithFrame:CGRectMake(10, titleView.frame.origin.y + titleView.frame.size.height+2, frame.size.width - 20, 21)];
        _lblNumOfVideo.font = [UIFont fontWithName:kFontRegular size:14];
        _lblNumOfVideo.textColor = UIColorFromRGB(0xa4a4a4);
        
        UIView *sepratorView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-0.5, 0, 1.0, frame.size.height)];
        sepratorView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = UIColorFromRGB(0xfcfcfc);
        
        [self addSubview:titleView];
        [self addSubview:_lblNumOfVideo];
        [self addSubview:sepratorView];
        [self addSubview:button];
    }
    return self;
}

- (void)loadContentSeason {
    if (_season) {
        _lblPlaylistName.text = _season.seasonName;
        _lblNumOfVideo.text = [NSString stringWithFormat:@"%d videos",_season.videosCount];
        CGFloat heightTitle = [Utilities heightForCellWithContent:_season.seasonName font:_lblPlaylistName.font width:_lblPlaylistName.frame.size.width];
        if (heightTitle > 40) {
            heightTitle = 40;
        }
        _lblPlaylistName.frame = CGRectMake(0, 7, self.frame.size.width - 20, heightTitle);
        _lblNumOfVideo.frame = CGRectMake(10, _lblPlaylistName.frame.origin.y + _lblPlaylistName.frame.size.height+2, self.frame.size.width - 20, 21);
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _lblPlaylistName.textColor = UIColorFromRGB(0x00adef);
    } else {
        _lblPlaylistName.textColor = UIColorFromRGB(0x212121);
    }
    _selected = selected;
}

- (void)buttonAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didTappedItem:)]) {
        [_delegate didTappedItem:self];
    }
}

@end
