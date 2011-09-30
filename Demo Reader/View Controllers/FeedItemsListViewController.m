//
//  FeedItemsListViewController.m
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import "FeedItemsListViewController.h"
#import "Feed.h"

@implementation FeedItemsListViewController

@synthesize feed;

- (void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        FeedItem *item = [self.feed.items objectAtIndex:indexPath.row];
        [item downloadImage];
    }

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
    
    //Set ourselves as the delegate for all the feed items to be notified
    //when images are downloaded
    [self.feed.items makeObjectsPerformSelector:@selector(setDelegate:) 
                                     withObject:self];
}

#pragma mark FeedItemDelegateMethods
-  (void)feedItemDidFinishDownloadingImage:(FeedItem *)item {
    NSInteger itemIndex = [self.feed.items indexOfObject:item];
    UITableViewCell *itemCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
    itemCell.imageView.image = [item itemImage];
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
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    FeedItem *item = [feed.items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item title];
    cell.detailTextLabel.text = [item pubDate];
    cell.imageView.image = [item itemImage];
        
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
    {
        [item downloadImage];
    }

    
    return cell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


#pragma mark cleanup
- (void)dealloc
{
    [super dealloc];
}


@end
