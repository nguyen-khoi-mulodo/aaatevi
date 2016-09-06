//
//  UIGridViewDelegate.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIGridViewDelegate


@optional
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex;


@required
- (CGFloat) gridView:(UIGridView *)grid heightForHeaderInSection:(int) section;
- (UIView*) gridView:(UIGridView *)grid viewForHeaderInSection:(NSInteger)section;
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex;
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex;
- (NSInteger) gridView:(UIGridView *)grid numberOfRowsInSection:(NSInteger)section;

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid;
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid;
- (NSInteger) numberOfSectionsInGridView:(UIGridView *)grid;


- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex andSection:(int) section;
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex andSection:(int) section;

@end

