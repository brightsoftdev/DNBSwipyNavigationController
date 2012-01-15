//
//  SampleViewController.m
//  DeckControllerSample
//
//  Created by Aaron Alexander on 12/11/11.
//  Copyright (c) 2011 drunknbass. All rights reserved.
//

#import "SampleViewController.h"



@interface SampleViewController()
- (void)fixBackgroundLayoutForOrientation:(UIInterfaceOrientation)orientation;
@property (nonatomic, assign) ControllerTheme theme;
@end



@implementation SampleViewController
@synthesize bar = _bar;
@synthesize theme = _theme;
@synthesize closeButton;
@synthesize titleItem;
@synthesize backgroundView = _backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    titleItem.title = [NSString stringWithFormat:@"%i", self.hash];
    self.view.tag = self.hash;
    
    self.theme = ControllerThemeFacebook;
    if ([self.navigationController.viewControllers count] > 1) {
        NSInteger i = [self.navigationController.viewControllers indexOfObject:self]-1;
        SampleViewController *s = (SampleViewController*)[self.navigationController.viewControllers objectAtIndex:i];
        self.theme = s.theme;
    }

}
- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController != nil) {
        self.bar.hidden = YES;
    }
    
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;

    switch (_theme) {
        case ControllerThemeFacebook:
            self.navigationController.leftController = [[UIViewController alloc] initWithNibName:@"FacebookLeftController" bundle:nil];
            c.bounceEnabled = NO;
            if (self == [c.viewControllers objectAtIndex:0]) {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBarIconLauncher"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftController)];
                self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:78.0/255.0 green:104.0/255.0 blue:160.0/255.0 alpha:1];
                self.navigationItem.leftBarButtonItem.enabled = YES;
            }
            break;
        case ControllerThemePath:
            self.navigationController.leftController = [[UIViewController alloc] initWithNibName:@"PathLeftController" bundle:nil];
            c.bounceEnabled = YES;
            if (self == [c.viewControllers objectAtIndex:0]) {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftController)];
                self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:164.0/255.0 green:32.0/255.0 blue:15.0/255.0 alpha:1];
                self.navigationItem.leftBarButtonItem.enabled = YES;
            }
            break;
    }
    
    self.navigationController.delegate = self;
    [self fixBackgroundLayoutForOrientation:self.interfaceOrientation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.bar = nil;
    self.closeButton = nil;
    self.titleItem = nil;
    self.backgroundView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return ( _theme == ControllerThemeFacebook ? YES : (UIInterfaceOrientationPortrait == interfaceOrientation) );
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fixBackgroundLayoutForOrientation:toInterfaceOrientation];
}

- (void)fixBackgroundLayoutForOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        CGRect r = self.backgroundView.frame;
        r.size.width = [[UIScreen mainScreen] applicationFrame].size.width;
        r.size.height = [[UIScreen mainScreen] applicationFrame].size.height - self.navigationController.navigationBar.frame.size.height;
        self.backgroundView.frame = r;
        if (self.theme == ControllerThemeFacebook) {
            self.backgroundView.image = [UIImage imageNamed:@"fbBG"];
        }
    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGRect r = self.backgroundView.frame;
        r.size.width = [[UIScreen mainScreen] applicationFrame].size.height;
        r.size.height = [[UIScreen mainScreen] applicationFrame].size.width - self.navigationController.navigationBar.frame.size.height;
        self.backgroundView.frame = r;
        if (self.theme == ControllerThemeFacebook) {
            self.backgroundView.image = [UIImage imageNamed:@"fbBGLandscape"];
        }
    }
}

- (IBAction)push:(id)sender {
    SampleViewController *controller = [[SampleViewController alloc] initWithNibName:@"SampleViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)pop:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)popLast:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)popToSelf:(id)sender {
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)presentModal:(id)sender {
    SampleViewController *controller = [[SampleViewController alloc] initWithNibName:@"SampleViewController" bundle:nil];
    [self.navigationController presentModalViewController:controller animated:YES];
}

- (IBAction)dismissModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)switchTheme:(id)sender {
    if (self.theme == ControllerThemeFacebook) {
        self.theme = ControllerThemePath;
    } else {
        self.theme = ControllerThemeFacebook;
    }
    
}

- (void)showLeftController {
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    if (c.currentPosition != ControllerPositionRight) {
        c.currentPosition = ControllerPositionRight;
    } else {
        c.currentPosition = ControllerPositionRegular;
    }
}
- (void)showRightController {
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    if (c.currentPosition != ControllerPositionLeft) {
        c.currentPosition = ControllerPositionLeft;
    } else {
        c.currentPosition = ControllerPositionRegular;
    }
}


#pragma mark - Properties

- (void)setTheme:(ControllerTheme)theme {
    
    _theme = theme;
    
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;

    switch (_theme) {
        case ControllerThemeFacebook: {
            [c.navigationBar addGestureRecognizer:c.panGestureRecognizer];
            c.leftController = [[UIViewController alloc] initWithNibName:@"FacebookLeftController" bundle:nil];
            c.bounceEnabled = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All Stories" style:UIBarButtonItemStylePlain target:self action:nil];
            self.backgroundView.image = [UIImage imageNamed:@"fbBG"];
            [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"NavBarButtonPortrait"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarPortrait"] forBarMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarLandscape"] forBarMetrics:UIBarMetricsLandscapePhone];            
        }   break;
        case ControllerThemePath: {
            [c.view addGestureRecognizer:c.panGestureRecognizer];
            c.leftController = [[UIViewController alloc] initWithNibName:@"PathLeftController" bundle:nil];
            c.rightController = [[UIViewController alloc] initWithNibName:@"PathRightController" bundle:nil];
            c.bounceEnabled = YES;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-friends-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightController)];
            self.backgroundView.image = [UIImage imageNamed:@"pathBG"];
            [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar-button"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar"] forBarMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar"] forBarMetrics:UIBarMetricsLandscapePhone];
            
        }   break;
    }
    
    // This is a nasty hack but i dont know of a proper way to get stuff to refresh
    [self.navigationController presentModalViewController:[UIViewController new] animated:NO];
    [self.navigationController dismissModalViewControllerAnimated:NO];
        
}

#pragma mark - DNBSwipyNavigationControllerDelegate

- (BOOL)rightControllerEnabled {
    return ( _theme == ControllerThemeFacebook ? NO : YES );
}

@end
