//
//  RowTable.h
//  NPlus
//
//  Created by Anh Le Duc on 8/1/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RowTableDelegate;
@interface RowTable : UIView
-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withData:(NSArray *)data withSection:(NSString*)key;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSString *key;
@property (nonatomic, weak) id<RowTableDelegate> delegate;
@end

@protocol RowTableDelegate <NSObject>

@optional
- (void)rowTable:(RowTable*)rowTable selected:(NSString*)key index:(NSInteger)index;

@end