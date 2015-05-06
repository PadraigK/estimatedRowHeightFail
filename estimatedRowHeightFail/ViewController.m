//
//  ViewController.m
//  estimatedRowHeightFail
//
//  Created by Padraig O Cinneide on 2015-05-05.
//  Copyright (c) 2015 Supertop. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger numberOfRows;

@end

@implementation ViewController

- (IBAction)jumpToEnd:(id)sender {
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow: self.numberOfRows-1 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastRow
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
    
    // FIRST BUG
    // DESCRIPTION: scrollToRowAtIndexPath:atScrollPosition:animated: is broken when using estimatedRowHeight.
    
    // Tap "Go To Bottom"
    // if the total for all estimated heights is > actual heights, we zoom past the end and get a blank screen.
    // if the total for all estimated heights is < actual heights, we don't reach the end — the scroller is not 100% of the way.
    
    // The results differ between `animated` being YES or NO, but neither is correct.
    
    // SECOND BUG:
    // DESCRIPTION: After scrolling past a cell that never gets its heightForRowAtIndexPath called, cells drawn when scrolling back up flicker wildly.
    
    // 1. Tap "Go To Bottom" once — it'll end up halfway down the table thanks to the first bug, but that's fine for now.
    // 2. Using your finger, start slowly scrolling back up towards the top of the table.
    // 3. After scrolling 10-15 cells the cells all suddenly scroll much faster than they should be.
    // 4. Things are normal again until you scroll up another 10 or so cells...
    
    // NOTE: Manually scrolling fast enough to skip a cell causes this too, but the scrollToRowAtIndexPath method here illustrates it easiest.
    // The wider the difference between estRowHeight and actualHeight, the worse this gets — it is noticable even with 5pt differences though.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfRows = 1000;
    
    self.tableView.estimatedRowHeight = 20;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell"];
    
    cell.contentView.backgroundColor = [self randomColor];
    
    return cell;
}

#pragma Helpers


- (UIColor *)randomColor {
    CGFloat hue = ( arc4random_uniform(255) / 255.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random_uniform(255) / 255.0 );  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random_uniform(255) / 255.0 );  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];

    return color;
}

@end
