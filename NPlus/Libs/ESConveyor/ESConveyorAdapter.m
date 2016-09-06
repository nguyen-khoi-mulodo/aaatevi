//
// Created by Eduardo Scoz on 6/8/13.
// Copyright (c) 2013 ESCOZ. All rights reserved.
//

#import "ESConveyorAdapter.h"
#import "ESConveyorController.h"
#import "ESConveyorView.h"
#import "ESConveyorFlowLayout.h"
#import "ESConveyorView.h"
#import "ESConveyorElement.h"
#import "ESConveyorPageCell.h"
#import "ESConveyorBelt.h"

static NSString *const ESConveyorElementReuseIdentifier = @"ESConveyorElementReuseIdentifier";
NSString *kESConveyorCell = @"ESConveyorCell";

@interface ESConveyorAdapter ()<UIScrollViewDelegate>
@property(nonatomic, weak) UICollectionView *collectionView;
@end

@implementation ESConveyorAdapter
{

}
- (id)initWithCollectionView:(UICollectionView *)collectionView numberOfPages:(NSInteger)pages elements:(NSArray *)elements
{

    self = [super init];
    if (self)
    {
        self.collectionView = collectionView;
        self.numberOfPages = pages;
        self.elements = elements;

        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;

        [self.collectionView registerClass:[ESConveyorPageCell class] forCellWithReuseIdentifier:kESConveyorCell];
        [self.collectionView registerClass:[ESConveyorView class] forSupplementaryViewOfKind:NSStringFromClass(ESConveyorElement.class) withReuseIdentifier:ESConveyorElementReuseIdentifier];

    }

    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfPages;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([ESConveyorElementKind isEqualToString:kind]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ESConveyorElementReuseIdentifier forIndexPath:indexPath];
    }

    NSAssert(NO, @"This should never happen");
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:kESConveyorCell forIndexPath:indexPath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.elements) {
        return;
    }
    for (ESConveyorElement *element in self.elements) {
        NSInteger animaType = [element animationEffects];
        if (animaType == ESAnimationRotation) {
            [self stopAnimationRotationView:element.view];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (ESConveyorElement *element in self.elements) {
        NSInteger animaType = [element animationEffects];
        if (animaType == ESAnimationRotation) {
            
            [self startAnimationRotationView:element.view];
        }
    }
}

- (void)startAnimationRotationView:(UIView*)view{
    if (![view.layer animationForKey:@"rotationAnimation"])
    {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 3.0f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        
        [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)stopAnimationRotationView:(UIView*)view{
    [view.layer removeAllAnimations];
}

@end