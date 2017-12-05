//
//  Flickr.m
//  FlickrPic
//
//  Created by Алексей on 23.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import "Flickr.h"

@implementation Flickr{
    const NSString *key; // @"2597dd27154bcea8c20fc867defe6ac6";
    NSString* token;
    NSURLSession* session;
}

-(id)init{
    key = @"2597dd27154bcea8c20fc867defe6ac6";
    session = [NSURLSession sharedSession];
    return self;
}

-(void)GetHotTags: (int) count success:(void (^)(NSArray *responseArray))success failure:(void(^)(NSError* error))failure
{
    NSMutableArray* ar = [[NSMutableArray alloc] init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.tags.gethotlist&nojsoncallback=1&format=json&api_key=%@&count=%d", key, count]];
    NSURLSessionTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error == nil){
            NSError *e = nil;
            NSDictionary *request = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &e];
            
            if([[request valueForKey:@"stat"]  isEqual: @"ok"]){
                
                NSDictionary *tags  =  [[request valueForKey:@"hottags"] valueForKey:@"tag"];
                for(NSDictionary *tag in tags){
                    [ar addObject:[tag valueForKey:(@"_content")]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{ success(ar); }); //return into main thread
            }
            else
            {
                //bad request from server
            }
        }
        else
        {
            //error in NSURLSessionTask
            dispatch_async(dispatch_get_main_queue(), ^{ failure(error); }); //return into main thread
        }
    }];
    [task resume];
}


-(void)GetIm: (NSString *) ImId Size:(NSString *) size success:(void (^)(UIImage *image))success failure:(void(^)(NSError* error))failure{
    
    __block NSString * imageUrl;


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.photos.getSizes&nojsoncallback=1&format=json&api_key=%@&photo_id=%@", key, ImId]];
    
    NSURLSessionTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *e = nil;
        NSDictionary *request = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &e];
        
        if(error == nil)
        {
            if([[request valueForKey:@"stat"]  isEqual: @"ok"])
            {
                NSDictionary *photosize  =  [[request valueForKey:@"sizes"] valueForKey:@"size"];
            
                for(NSDictionary *photo in photosize)
                {
                    if([[photo valueForKey:(@"label")] isEqualToString:size]) //find matching size
                    {
                        imageUrl = [photo valueForKey:(@"source")];
                        break;
                    }
                }
                [self DownloadPic:[NSURL URLWithString:imageUrl] success:^(UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{ success(image); }); //return into main thread
                }
                failure:^(NSError *e) {
                    dispatch_async(dispatch_get_main_queue(), ^{ failure(e); }); //return into main thread
                }];
            }
            else
            {
                //bad request from server
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{ failure(error); }); //return into main thread
        }
    }];
    [task resume];
}

-(void)DownloadPic: (NSURL *) Url success:(void (^)(UIImage *image))success failure:(void(^)(NSError* error))failure{
    
    NSURLSessionDownloadTask* downloadtask = [session downloadTaskWithURL:Url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error == nil) success([UIImage imageWithData:[NSData dataWithContentsOfURL:location]]);
        else failure(error);
        
    }];
    [downloadtask resume];
}

-(void)GetImId: (NSString *) tag success:(void (^)(NSArray *responseArray))success failure:(void(^)(NSError* error))failure
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.photos.search&nojsoncallback=1&format=json&api_key=%@&tags=%@", key, tag]];
    
    NSURLSessionTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if(error == nil)
        {
            NSError *e = nil;
            NSDictionary *request = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &e];
            
            if([[request valueForKey:@"stat"]  isEqual: @"ok"])
            {
                NSDictionary *photo  =  [[request valueForKey:@"photos"] valueForKey:@"photo"];
                
                for(NSDictionary *tag in photo)
                {
                    [result addObject: [tag valueForKey:(@"id")]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{ success(result); }); //return into main thread
            }
            else
            {
                //bad request from server
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{ failure(error); }); //return into main thread
        }
    }];
    [task resume];
}

@end
