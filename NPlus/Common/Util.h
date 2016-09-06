//
//  Util.h
//  NCT iPad
//
//  Created by Vo Chuong Thien on 1/19/15.
//  Copyright (c) 2015 thienvc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenInfo.h"
#import "SubTitle.h"

@interface Util : NSObject
+ (Util *)sharedInstance;

- (void)saveToken:(TokenInfo*) info;
- (TokenInfo*) getToken;
- (NSString*) getAccessToken;
- (NSString*) decryptedSubtitle:(SubTitle*) sub;
- (BOOL) hardcodeShowInfomation:(NSString*) keyword;
+ (CGFloat) heightForCellWithContent:(NSString *)text withFont:(UIFont*) font;
+ (CGFloat) heightForContent:(NSString *)text withFont:(UIFont*) font andWidth:(float) width;
+ (CGFloat) heightForContent:(NSString *)text withFont:(UIFont*) font andWidth:(float) width andHeight:(float) height;
+ (NSString *) getDiskSpaceInfo;
+ (NSString *) getRatioWithBytesWritten:(double) bytesWritten BytesExpectedToWrite:(double) bytesExpectedToWrite;
+ (NSString *) getByteExecdtedWritten:(double) bytesExpectedToWrite;
@end
