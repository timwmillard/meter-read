//
//  TMXTabBarController.m
//  MeterRead
//
//  Created by Tim Millard on 16/07/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXTabBarController.h"

#import "TMXAppDelegate.h"
#import "TMXImportOperation.h"
#import "TMXMasterViewController.h"

@interface TMXTabBarController ()

@end

@implementation TMXTabBarController
{
    UIView *_importView;
    UIActivityIndicatorView *_spinner;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // observe the keypath change to get notified of the end of the parser operation to hid the activity indicator
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.backgroundQueue addObserver:self forKeyPath:@"operationCount" options:0 context:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performImportCSVFile:(NSURL *)url
{
    // if (section.count > 0 ) {
        [self performSegueWithIdentifier:@"showImport" sender:self];
    //} else {
    //  [self importCVSFile:url];
    //}
}

- (IBAction)unwindFromImportViewController:(UIStoryboardSegue *)segue
{
    //[self importCVSFile:url];
}
    
- (void)importCSVFile:(NSURL *)url
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    TMXImportOperation *import = [[TMXImportOperation alloc] initWithURL:url
                                        sharedPersistentStoreCoordinator:delegate.persistentStoreCoordinator];
    
    int width = self.view.window.frame.size.width;
    int height = 50;
    int x = 0;
    int y = self.tabBar.frame.origin.y - height;
    
    if (_importView == nil) {
        _importView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];

    
        _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [_spinner setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
         UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleTopMargin |
         UIViewAutoresizingFlexibleBottomMargin];
        [_spinner startAnimating];
    
        
        _importView.backgroundColor = [UIColor blackColor];
        //_importView.opaque = NO;
        //_importView.alpha = 0.8;
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 280, 50)];
        label.backgroundColor = [UIColor blackColor];
        label.opaque = NO;
        label.alpha = 0.6;
        label.textColor = [UIColor whiteColor];
        label.text = @"Importing from CSV file ...";
        
        _spinner.opaque = NO;
        _spinner.alpha = 0.6;
        _spinner.backgroundColor = [UIColor blackColor];
    
        [_importView addSubview:_spinner];
        [_importView addSubview:label];
        [self.view addSubview:_importView];
    }
    
    [delegate.backgroundQueue addOperation:import];
    
}

- (void)finishImport
{
    NSLog(@"finishImport\n");
    [self hideActivityIndicator];
    
    UINavigationController *navigationController = (UINavigationController *)self.viewControllers[0];
    TMXMasterViewController *listController = (TMXMasterViewController *)navigationController.viewControllers[0];
    
    UINavigationController *navigationControllerGroup = (UINavigationController *)self.viewControllers[2];
    TMXMasterViewController *listControllerGroup = (TMXMasterViewController *)navigationControllerGroup.viewControllers[0];
    
    [listController reloadTableView];
    [listControllerGroup reloadTableView];
}

// stop the animation of activityIndicator and hide it
- (void)hideActivityIndicator
{   
    // stop our activity indicator
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
    [_importView removeFromSuperview];
    _importView = nil;
    _spinner = nil;
    

}

// observe the queue's operationCount, stop activity indicator if there is no operatation ongoing.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (object == delegate.backgroundQueue && [keyPath isEqualToString:@"operationCount"]) {
        
        if (delegate.backgroundQueue.operationCount == 0) {
            [self performSelectorOnMainThread:@selector(finishImport) withObject:nil waitUntilDone:NO];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
