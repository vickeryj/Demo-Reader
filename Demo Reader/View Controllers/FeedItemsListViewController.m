//
//  FeedItemsListViewController.m
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import "FeedItemsListViewController.h"
#import "Feed.h"
#import "FeedItem.h"

@implementation FeedItemsListViewController

@synthesize feed;

- (void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad {
    
    self.tableView.rowHeight = 80.f;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [infoButton addTarget:self 
                   action:@selector(dismiss) 
         forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


#pragma mark - UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feed.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 2;
    }
    
    cell.textLabel.text = [[feed.items objectAtIndex:indexPath.row] title];
    cell.detailTextLabel.text = [[feed.items objectAtIndex:indexPath.row] pubDate];
        
    return cell;
}

#pragma mark cleanup
- (void)dealloc
{
    [super dealloc];
}


@end
