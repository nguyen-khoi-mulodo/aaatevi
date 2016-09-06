//
//  UILabelViewFlowLayout.h
//  AFTabledCollectionView
//
//  Created by Khoi Nguyen Nguyen on 1/7/16.
//  Copyright © 2016 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GenreTagViewDelegate <NSObject>

- (void)didTappedWithGenre:(Genre*)genre;

@end

@interface UILabelViewFlowLayout : UIView

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) id<GenreTagViewDelegate>delegate;

- (id)initWithData:(NSArray*)array;
- (void)arrangeSubViews;
@end
