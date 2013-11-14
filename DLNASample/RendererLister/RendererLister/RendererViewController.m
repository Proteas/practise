//
//  RendererViewController.m
//  RendererLister
//
//  Created by Proteas on 13-10-30.
//  Copyright (c) 2013年 Proteas. All rights reserved.
//

#import "RendererViewController.h"
#import "PlayerViewController.h"
#import <CyberLink/UPnPAV.h>

static NSString *kCellIdentifier = @"RendererCell";

@interface RendererViewController () <CGUpnpControlPointDelegate>
{
    NSMutableArray *_rendererList;
    CGUpnpAvController *_avController;
    UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, strong) CGUpnpAvController *avController;
@property (nonatomic, strong) NSMutableArray *rendererList;

@end

@implementation RendererViewController
@synthesize avController = _avController;
@synthesize rendererList = _rendererList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.avController = [[CGUpnpAvController alloc] init];
        self.avController.delegate = self;
        _rendererList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.avController stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Renderer List";
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize appSize = [[UIScreen mainScreen] applicationFrame].size;
    CGRect frm = _activityIndicator.frame;
    frm.origin.x = (appSize.width - frm.size.width) / 2.0f;
    frm.origin.y = (appSize.height - frm.size.height) / 2.0f;
    _activityIndicator.frame = frm;
    [self.view addSubview:_activityIndicator];
    _activityIndicator.hidden = YES;

    self.clearsSelectionOnViewWillAppear = YES;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
 
    UIBarButtonItem *findBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Find" style:UIBarButtonItemStyleBordered target:self action:@selector(onFinderRenderer:)];
    self.navigationItem.rightBarButtonItem = findBtnItem;
}

- (void)showFindingStatus
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void)stopFindingStatus
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
}

- (void)onFinderRenderer:(id)sender
{
    [self.avController search];
    [self showFindingStatus];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rendererList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    CGUpnpAvRenderer *renderer = [_rendererList objectAtIndex:indexPath.row];
    cell.textLabel.text = [renderer.friendlyName stringByAppendingFormat:@"-%@", renderer.ipaddress];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PlayerViewController *player = [[PlayerViewController alloc] init];
    player.avRenderer = [_rendererList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:player animated:YES];
}

#pragma -
#pragma mark - UPNP Control Point Delegate Methods

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceAdded:(NSString *)deviceUdn
{
    self.rendererList =  [NSMutableArray arrayWithArray:[((CGUpnpAvController*)controlPoint) renderers]];
    NSArray* renderers = [((CGUpnpAvController*)controlPoint) renderers];
    if ([renderers count] > 0) {
        for (CGUpnpAvRenderer* renderer in renderers) {
            NSLog(@"avRendererUDN:%@", [renderer udn]);
        }
        [self performSelectorOnMainThread:@selector(stopFindingStatus) withObject:nil waitUntilDone:YES];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [_avController search];
    }
}

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn
{
    //
}

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceRemoved:(NSString *)deviceUdn
{
    //
}

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceInvalid:(NSString *)deviceUdn
{
    //
}

@end
