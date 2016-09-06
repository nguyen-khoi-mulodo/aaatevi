//
//  Utilities.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/16/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import "Utilities.h"
#import "QualityURL.h"

@implementation Utilities

#pragma mark - View
+ (id)loadView:(Class)class FromNib:(NSString *)nibName {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    for (id obj in nibViews) {
        if ([obj isKindOfClass:class] || [obj isMemberOfClass:class]) {
            return obj;
        }
    }
    return nil;
}


+ (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 2.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

+ (CGFloat)heightForCellWithContent:(NSString *)text {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontRegular size:15],NSFontAttributeName, nil] context:nil];
    rect.size.width = SCREEN_SIZE.width - 20;
    if (rect.size.height < 28) {
        rect.size.height = 28;
    }
    return rect.size.height + 21;
}

+ (CGFloat)heightForCellWithContent:(NSString *)text font:(UIFont*)font width:(CGFloat)width{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect.size.height;
}

+ (NSString*)getRefreshToken {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"REFRESH_TOKEN"]) {
        return [userDefault objectForKey:@"REFRESH_TOKEN"];
    }
    return nil;
}

+ (void)saveRefreshToken:(NSString *)reToken {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:reToken forKey:@"REFRESH_TOKEN"];
    [userDefault synchronize];
}

+ (void)saveAccessToken:(NSString *)access_token {
    [kNSUserDefault setObject:access_token forKey:@"access_token"];
    [kNSUserDefault synchronize];
}

+ (NSString*)getAccessToken {
    if ([kNSUserDefault objectForKey:@"access_token"]) {
        return [[kNSUserDefault objectForKey:@"access_token"] description];
    }
    return @"";
}

+ (NSDictionary*)getUserInfo {
    if ([kNSUserDefault objectForKey: kUserDefaultUser]) {
        return (NSDictionary*)[kNSUserDefault objectForKey: kUserDefaultUser];
    }
    return nil;
}

+ (void)setUserInfoWithEmail:(NSString *)email name:(NSString *)name fbUsername:(NSString *)fbUsername avatar:(NSString *)avatar{
    NSDictionary *info = @{kUserEmail:email,kUserDisplayName:name,kUserName:fbUsername,kUserAvatar:avatar};
    [kNSUserDefault setObject:info forKey:kUserDefaultUser];
    [kNSUserDefault synchronize];
}

+ (BOOL)checkLogined {
    if ([kNSUserDefault objectForKey:kUserLogined]) {
        return [[kNSUserDefault objectForKey:kUserLogined]boolValue];
    }
    return NO;
}
+ (void)setLogined:(BOOL)logined {
    [kNSUserDefault setObject:[NSNumber numberWithBool:logined] forKey:kUserLogined];
    [kNSUserDefault synchronize];
}

+ (BOOL)getHDChecked {
    if ([kNSUserDefault objectForKey:kUserDefaultHD]) {
        return [[kNSUserDefault objectForKey:kUserDefaultHD]boolValue];
    }
    return NO;
}
+ (void)setHDChecked:(BOOL)isHD {
    [kNSUserDefault setObject:[NSNumber numberWithBool:isHD] forKey:kUserDefaultHD];
    [kNSUserDefault synchronize];
}

+ (void)setCurQualityLinkOfVideo:(Video *)video {
    if (video.videoStream) {
        QualityURL *qualityURL = nil;
        QualityURL *qualityDownload = nil;
        if ([Utilities getHDChecked]) {
            qualityURL = [video.videoStream.streamUrls objectAtIndex:1];
            qualityDownload = [video.videoStream.streamDownloads objectAtIndex:1];
        } else {
            qualityURL = [video.videoStream.streamUrls objectAtIndex:0];
            qualityDownload = [video.videoStream.streamDownloads objectAtIndex:0];
        }
        video.link_down = qualityDownload.link;
        video.stream_url = qualityURL.link;
    }
}
+ (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSString *timeString =@"";
    NSString *formatString=@"";
    
    if (hours > 0) {
        formatString = @"%d:%02d:%02d";
        timeString = [NSString stringWithFormat:formatString, hours, minutes, seconds];
    }else{
        formatString = @"%02d:%02d";
        timeString = [NSString stringWithFormat:formatString, minutes, seconds];
    }
    
//    if(hours > 0){
//        formatString=hours==1?@"%02d:":@"%02d:";
//        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,hours]];
//    }
//    if(minutes > 0 || hours > 0 ){
//        formatString=minutes==1?@"%02d:":@"%02d:";
//        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,minutes]];
//    } else if (minutes <= 0) {
//        timeString=@"00:";
//    }
//    if(seconds > 0 || hours > 0 || minutes > 0){
//        formatString=seconds==1?@"%02d":@"%02d";
//        timeString  = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,seconds]];
//    }
    return timeString;
}

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    [hud hide:YES afterDelay:20];
    return hud;
}

+ (MBProgressHUD *)showGlobalProgressHUDNoTimeoutWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    return hud;
}

+ (void)dismissGlobalHUD {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideHUDForView:window animated:YES];
}
+ (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationDown];
    
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (NSString*)convertToStringFromCount:(long)count {
    NSString *string = [NSString stringWithFormat:@"%ld",count];
    float view = 0.0;
    if (count/1000000000 > 0) {
        view = (float)count/1000000000;
        string = [NSString stringWithFormat:@"%.01fB",view];
    } else if (count/1000000 > 0) {
        view = (float)count/1000000;
        string = [NSString stringWithFormat:@"%.01fM",view];
    } else if (count/1000 > 0) {
        view = (float)count/1000;
        string = [NSString stringWithFormat:@"%.01fK",view];
    }
    return string;
}

+ (NSString*)stringDateFromMiliseconds:(NSTimeInterval)time {
    NSDate *date  = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSCalendar *calendarGreg = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setCalendar:calendarGreg];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *str = [formatter stringFromDate:date];
    return str;
}
+ (NSString*)stringRelatedDateFromMiliseconds:(NSTimeInterval)time {
    
    NSDate *dateTime = nil;
    int timeAgo = 0;
    NSDictionary *timeScale = @{@"giây trước"  :@1,
                                @"phút trước"  :@60,
                                @"giờ trước"   :@3600,
                                @"ngày trước"  :@86400,
                                @"tuần trước" :@605800,
                                @"tháng trước":@2629743,
                                @"năm trước" :@31556926};
    
    
    dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    timeAgo = 0-(int)[dateTime timeIntervalSinceNow];
    
    
    NSString *scale;
    if (timeAgo < 60) {
        scale = @"giây trước";
    } else if (timeAgo < 3600) {
        scale = @"phút trước";
    } else if (timeAgo < 86400) {
        scale = @"giờ trước";
    } else if (timeAgo < 605800) {
        scale = @"ngày trước";
    } else if (timeAgo < 2629743) {
        scale = @"tuần trước";
    } else if (timeAgo < 31556926) {
        scale = @"tháng trước";
    } else {
        scale = @"năm trước";
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    
    return [NSString stringWithFormat:@"%d %@", timeAgo, scale];
}

+ (NSString*)stringRelatedDateFromMilisecondsLessWeek:(NSTimeInterval)time {
    
    NSDate *dateTime = nil;
    int timeAgo = 0;
    NSDictionary *timeScale = @{@"giây trước"  :@1,
                                @"phút trước"  :@60,
                                @"giờ trước"   :@3600,
                                @"ngày trước"  :@86400,
                                @"tuần trước" :@605800,
                                @"tháng trước":@2629743,
                                @"năm trước" :@31556926};
    
    
    dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    timeAgo = 0-(int)[dateTime timeIntervalSinceNow];
    
    
    NSString *scale;
    if (timeAgo < 60) {
        scale = @"giây trước";
    } else if (timeAgo < 3600) {
        scale = @"phút trước";
    } else if (timeAgo < 86400) {
        scale = @"giờ trước";
    } else if (timeAgo < 31556926) {
        scale = @"ngày trước";
    }  else {
        return [self stringDateFromMiliseconds:time];
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    return [NSString stringWithFormat:@"%d %@", timeAgo, scale];
}

+ (void)setTypeGenre:(NSString *)type {
    [kNSUserDefault setObject:type forKey:@"typeGenre"];
    [kNSUserDefault synchronize];
}

+ (NSString*)getTypeGenre {
    NSString *type = @"Mới";
    if ([kNSUserDefault objectForKey:@"typeGenre"]) {
        type = [kNSUserDefault objectForKey:@"typeGenre"];
        type = [type isEqualToString:NEW_TYPE] ? @"Mới":@"Hot";
    }
    return type;
}


+ (NSMutableAttributedString*)getAttributeText:(NSString*)string forSubstring:(NSString*)subStr fillColor:(UIColor *)color font:(UIFont*)font{
    if (!string || string.length == 0) {
        return nil;
    }
    
    NSString *text = string;
    subStr = subStr.lowercaseString;
    NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithString:text];
    
    [mutable addAttribute: NSForegroundColorAttributeName value:color range:[text.lowercaseString rangeOfString:subStr]];
    [mutable addAttribute:NSFontAttributeName value:font range:[text.lowercaseString rangeOfString:subStr]];
    
    return mutable;
}
@end
