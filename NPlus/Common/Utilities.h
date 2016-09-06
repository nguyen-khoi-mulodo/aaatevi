//
//  Utilities.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/16/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Utilities : NSObject

// ----- UIView--------------
+ (id)loadView:(Class)class FromNib:(NSString*)nibName;
+ (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius;
+ (CGFloat)heightForCellWithContent:(NSString *)text;
+ (CGFloat)heightForCellWithContent:(NSString *)text font:(UIFont*)font width:(CGFloat)width;
+ (NSDictionary*)getUserInfo;
+ (void)setUserInfoWithEmail:(NSString*)email name:(NSString*)name fbUsername:(NSString *)fbUsername avatar:(NSString*)avatar;
+ (BOOL)checkLogined;
+ (void)setLogined:(BOOL)logined;
+ (BOOL)getHDChecked;
+ (void)setHDChecked:(BOOL)isHD;
+ (void)setCurQualityLinkOfVideo:(Video*)video;
+ (NSString*)getRefreshToken;
+ (void)saveRefreshToken:(NSString *)reToken;
+ (void)saveAccessToken:(NSString *)access_token;
+ (NSString*)getAccessToken;
+ (NSString *)timeFormatted:(int)totalSeconds;
+ (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (MBProgressHUD *)showGlobalProgressHUDNoTimeoutWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;

+ (NSString*)convertToStringFromCount:(long)count;
+ (NSString*)stringDateFromMiliseconds:(NSTimeInterval)time;
+ (NSString*)stringRelatedDateFromMiliseconds:(NSTimeInterval)time;
+ (NSString*)stringRelatedDateFromMilisecondsLessWeek:(NSTimeInterval)time;
+ (void)setTypeGenre:(NSString*)type;
+ (NSString*)getTypeGenre;
+ (NSMutableAttributedString*)getAttributeText:(NSString*)string forSubstring:(NSString*)subStr fillColor:(UIColor *)color font:(UIFont*)font;
@end
