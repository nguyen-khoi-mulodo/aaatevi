//
//  CustomFlowLayout.m
//  NPlus
//
//  Created by Anh Le Duc on 12/3/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // Use your own index path and kind here
    UICollectionViewLayoutAttributes *backgroundLayoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:@"background" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    [attributes addObject:backgroundLayoutAttributes];
    
    return [attributes copy];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:@"background"]) {
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        attrs.size = [self collectionViewContentSize];
        attrs.bounds = CGRectMake(0, 0, attrs.size.width, attrs.size.height);
        attrs.zIndex = -10;
        return attrs;
    } else {
        return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    }
}
@end
