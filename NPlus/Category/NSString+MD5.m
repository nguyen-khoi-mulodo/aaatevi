

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)
-(NSString*) md5{
	const char *cStrValue = [self UTF8String]; 
	unsigned char theResult[CC_MD5_DIGEST_LENGTH]; 
	CC_MD5(cStrValue, strlen(cStrValue), theResult);
	
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X" 
			@"%02X%02X%02X%02X%02X%02X%02X%02X",
			theResult[0],theResult[1], theResult[2], theResult[3], 
			theResult[4], theResult[5], theResult[6], theResult[7], 
			theResult[8], theResult[9], theResult[10], theResult[11],
			theResult[12], theResult[13], theResult[14], theResult[15]			   ];
}
@end
