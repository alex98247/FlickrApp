//
//  ImagesCollectionViewController.h
//  FlickrPic
//
//  Created by Алексей on 27.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flickr.h"

@interface ImagesCollectionViewController : UICollectionViewController

@property (nonatomic, retain) NSString *str;
@property (nonatomic, retain) Flickr *flicr;


@end
