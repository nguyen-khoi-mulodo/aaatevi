//
//  DiscoverGenreItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 4/28/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "DiscoverGenreItemCell.h"

@implementation DiscoverGenreItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [lbTitle setFont:[UIFont fontWithName:kFontMedium size:17.0f]];
    [lbTitle setTextColor:UIColorFromRGB(0x212121)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) setHeightForCell:(float) height{
    [self.contentView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, height)];
}

- (void) setTitle:(NSString*) title andTag:(int) tag{
    [lbTitle setText:title];
    [loadingView startAnimating];
    [btnSelect setTag:tag];
}

- (void) setGenre:(Genre*) genre{
    genreCurrent = genre;
    int rows = [self getRowsWithGenre:genre];
    if ([genre.genreName isEqualToString:@"Short Film"]) {
        genre.genreName =  @"Phim ngắn";
    }
    [lbTitle setText:genre.genreName];
    if (genreView.subviews.count > 0) {
        for (UIView* v in genreView.subviews) {
            [v removeFromSuperview];
        }
    }
    int col = 3;
    float dX = 0;
    float dY = 0;
    float width = SCREEN_SIZE.width;
    float W = (width - dX * (col + 1)) / col;
    float H = 40.0f;
    int index = 0;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < col; j++) {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (j == 0 || j == col - 1) {
                [btn setFrame:CGRectMake(dX * (j + 1) + W * j - 1, dY * (i + 1) + H * i, W + 2, H + 1)];
            }else{
                [btn setFrame:CGRectMake(dX * (j + 1) + W * j, dY * (i + 1) + H * i, W, H + 1)];
            }
            index = i * col + j;
            if (index < genre.childGenres.count) {
                Genre* subGenre = [genre.childGenres objectAtIndex:index];
                [btn setTitle:subGenre.genreName forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"" forState:UIControlStateNormal];
                btn.hidden = YES;
            }
            [btn.layer setBorderColor:[UIColorFromRGB(0xe0e0e0) CGColor]];
            [btn.layer setBorderWidth:1.0f];
            [btn.titleLabel setFont:[UIFont fontWithName:kFontRegular size:14.0f]];
            [btn setTitleColor:UIColorFromRGB(0x747474) forState:UIControlStateNormal];
            [btn setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
            [btn setTag:index];
            [btn addTarget:self action:@selector(doSelectGenre:) forControlEvents:UIControlEventTouchUpInside];
            [genreView addSubview:btn];
        }
    }
    [loadingView stopAnimating];
}

- (int) getRowsWithGenre:(Genre*) genre{
    int countItems = (int)genre.childGenres.count;
    int rows = countItems / 3;
    if (countItems % 3 > 0) {
        rows ++;
    }
    return rows;
}

- (void) doSelectGenre:(id) sender{
    UIButton* btn = sender;
    int index = (int)btn.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectGenre:listGenres:index:)]) {
        [self.delegate didSelectGenre:genreCurrent listGenres:genreCurrent.childGenres index:index];
    }
}

- (IBAction) doSelectParentGenre:(id)sender{
    UIButton* btn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnGenreAction:)]) {
        [self.delegate btnGenreAction:btn];
    }
}

@end
