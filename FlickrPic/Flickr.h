//
//  Flickr.h
//  FlickrPic
//
//  Created by Алексей on 23.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flickr : NSObject
-(void)Flickr;
-(NSArray *)GetHotTags: (int) count;
-(NSArray *)GetImId: (NSString *) tag;
-(NSData *)GetIm: (NSString *) ImId;
@end
