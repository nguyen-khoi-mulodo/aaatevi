//
//  ListItemVC.h
//  NPlus
//
//  Created by Anh Le Duc on 9/10/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "CollectionViewBaseVC.h"
@protocol ListItemDelegate;
@interface ListItemVC : CollectionViewBaseVC
@property (nonatomic, assign) kItemCollectionType collectionType;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, weak) id<ListItemDelegate> delegate;
- (void)setShowGenre:(NSArray*)lstGenre;
@end

@protocol ListItemDelegate <NSObject>

@required
- (void)loadDataWithCurPage:(NSInteger)cPage withViewController:(ListItemVC*)viewController;
- (void)loadDataWithCurPage:(NSInteger)cPage withGenreId:(NSString*)genre_id withViewController:(ListItemVC *)viewController;
- (void)loadGenreWithViewController:(ListItemVC *)viewController;
@end
