//
//  JGARootViewController.m
//  sspullexample
//
//  Created by John Grant on 2013-07-16.
//  Copyright (c) 2013 JGApps. All rights reserved.
//

#import "JGARootViewController.h"

#import "SSPullToRefresh.h"

@interface JGARootViewController () <SSPullToRefreshViewDelegate>
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@end

static NSString *CellIdentifier = @"Cell";
@implementation JGARootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self addPullToRefresh];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Refresh by Code" style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = button;
}

#pragma mark - SSPullToRefresh
- (UIView <SSPullToRefreshContentView> *)pullToRefreshContentView {
    SSPullToRefreshSimpleContentView *view = [[SSPullToRefreshSimpleContentView alloc] init];
    return view;
}

- (void)addPullToRefresh {
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    self.pullToRefreshView.contentView = [self pullToRefreshContentView];
}

#pragma mark - SSPullToRefreshViewDelegate
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

- (void)refresh {
    [self.pullToRefreshView startLoading];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.pullToRefreshView finishLoading];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Section: %d Row: %d", indexPath.section, indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section: %d", section];
}

@end
