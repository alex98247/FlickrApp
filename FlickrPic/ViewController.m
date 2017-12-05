//
//  ViewController.m
//  FlickrPic
//
//  Created by Алексей on 23.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import "ViewController.h"
#import "Flickr.h"

@interface ViewController (){
    Flickr *fl;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(fl == nil)
    {
        fl = [[Flickr alloc] init];
        
        [fl GetIm:_imId Size:@"Large" success:^(UIImage *image) {
            _image.image = image;
        } failure:^(NSError *error) {
            //
        }];
    }
}


@end
