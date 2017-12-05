//
//  ImagesCollectionViewController.m
//  FlickrPic
//
//  Created by Алексей on 27.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import "ImagesCollectionViewController.h"
#import "Flickr.h"
#import "CollectionViewCell.h"
#import "ViewController.h"

@interface ImagesCollectionViewController (){
    NSMutableArray *images;
    NSMutableArray *imId;
    Flickr *fl;
}

@end

@implementation ImagesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(fl == nil)
    {
        fl = [[Flickr alloc] init];
        images = [[NSMutableArray alloc] init];
        imId = [[NSMutableArray alloc] init];
        
        [fl GetImId:_tag success:^(NSArray *arr) {
            //download earch photo from arr
            for(NSString *s in arr)
            {
                [fl GetIm:s Size:@"Square" success:^(UIImage *image) {
                    [images addObject:image]; //add image to array
                    [imId addObject:s]; //add image id to array
                    [self.collectionView reloadData];
                }
                failure:^(NSError *error) {
                        // error handling here
                }];
            }
        }
        failure:^(NSError *error) {
                // error handling here
        }];
    }
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagecell" forIndexPath:indexPath];
    cell.image.image = images[indexPath.row];
    // Configure the cell
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"ImageScreen"])
    {
        ViewController *vc = [segue destinationViewController];
        UICollectionViewCell *cell = (UICollectionViewCell *) sender;
        vc.imId = imId[[self.collectionView indexPathForCell:cell].row];
        //send image id
    }
}
@end
