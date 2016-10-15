//
//  Server.h
//  DialPhone
//
//  Created by 蔡瑞雄 on 2011/5/21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonFunc : NSObject {
    
}

+(BOOL) isJailbroken;
+(NSString*) getDateStr;
+(NSString*) getDateStr:(NSDate*) idate;
+(int) ComputeHash: (unsigned char*) data;
+(BOOL) validEmail:(NSString*) emailString;

@end
