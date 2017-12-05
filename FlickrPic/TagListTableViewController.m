//
//  TagListTableViewController.m
//  FlickrPic
//
//  Created by Алексей on 26.11.2017.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import "TagListTableViewController.h"
#import "Flickr.h"
#import "ImagesCollectionViewController.h"

@interface TagListTableViewController (){
    NSArray *tags;
    Flickr* fl;
}

@end

@implementation TagListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(fl == nil){
        fl = [[Flickr alloc] init];
        //[fl Flickr];
        
        [fl GetHotTags:10 success:^(NSArray *responseArray) {
            tags = responseArray;
            [self.tableView reloadData];
            //get hot tags from Flickr.com into array tags
        } failure:^(NSError *error) {
            // error handling here
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tag" forIndexPath:indexPath];
    cell.textLabel.text = tags[indexPath.row];
    // Configure the cell from array tags
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"SecondScreen"]){
        ImagesCollectionViewController *vc = [segue destinationViewController];
         UITableViewCell *cell = (UITableViewCell *) sender;
        vc.tag = cell.textLabel.text;
        //send tag
    }
}

@end
