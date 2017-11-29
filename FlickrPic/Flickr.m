//
//  Flickr.m
//  FlickrPic
//
//  Created by Алексей on 23.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import "Flickr.h"

@implementation Flickr{
    NSString* key; // @"2597dd27154bcea8c20fc867defe6ac6";
    NSString* token;
    NSURLSession* session;
    NSURL* url;
}

-(void)Flickr{
    key = @"2597dd27154bcea8c20fc867defe6ac6";
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
}

-(NSArray *)GetHotTags: (int) count
{
    __block NSMutableArray *result = [[NSMutableArray alloc] init];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.tags.gethotlist&nojsoncallback=1&format=json&api_key=%@&count=%d", key, count]];
    NSURLSessionTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *e = nil;
        NSDictionary *request = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &e];
        
        if([[request valueForKey:@"stat"]  isEqual: @"ok"]){
            
            NSDictionary *tags  =  [[request valueForKey:@"hottags"] valueForKey:@"tag"];
            for(NSDictionary *tag in tags){
                NSLog(@"Item: %@", [tag valueForKey:(@"_content")]);
                [result addObject: [tag valueForKey:(@"_content")]];
            }
            
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}

-(NSData *)GetIm: (NSString *) ImId{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];


    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.photos.getSizes&nojsoncallback=1&format=json&api_key=%@&photo_id=%@", key, ImId]];
    
    NSURLSessionTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *e = nil;
        NSDictionary *request = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &e];
        
        if([[request valueForKey:@"stat"]  isEqual: @"ok"]){
            
            NSDictionary *photosize  =  [[request valueForKey:@"sizes"] valueForKey:@"size"];
            for(NSDictionary *photo in photosize){
                if([[photo valueForKey:(@"label")] isEqualToString:@"Square"]) {
                    NSLog(@"Item: %@", [photo valueForKey:(@"source")]);
                    imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[photo valueForKey:(@"source")]]];
                }
            }
            
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    
    //cell.image = [UIImage imageWithData: imageData];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return imageData;
}

-(NSArray *)GetImId: (NSString *) tag
{
    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.photos.search&nojsoncallback=1&format=json&api_key=%@&tags=%@", key, tag]];
    NSURLSessionTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSError *e = nil;
        NSDictionary *request = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &e];
        
        if([[request valueForKey:@"stat"]  isEqual: @"ok"]){
            
            NSDictionary *photo  =  [[request valueForKey:@"photos"] valueForKey:@"photo"];
            for(NSDictionary *tag in photo){
                NSLog(@"Item: %@", [tag valueForKey:(@"id")]);
                [result addObject: [tag valueForKey:(@"id")]];
            }
            
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}

@end
