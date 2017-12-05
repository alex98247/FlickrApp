//
//  Flickr.h
//  FlickrPic
//
//  Created by Алексей on 23.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Flickr : NSObject
-(void)GetHotTags: (int) count  success:(void (^)(NSArray *responseArray))success failure:(void(^)(NSError* error))failure;
-(void)GetIm: (NSString *) ImId Size:(NSString *) size success:(void (^)(UIImage *image))success failure:(void(^)(NSError* error))failure;
-(void)GetImId: (NSString *) tag success:(void (^)(NSArray *responseArray))success failure:(void(^)(NSError* error))failure;
@end
