//
//  ViewController.h
//  FlickrPic
//
//  Created by Алексей on 23.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) NSString *imId;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

