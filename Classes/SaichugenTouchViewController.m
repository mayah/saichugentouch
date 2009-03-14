//
//  SaichugenTouchViewController.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 11/30/08.
//  Copyright YUHA 2008. All rights reserved.
//

#import "SaichugenTouchAppUtility.h"
#import "SaichugenTouchViewController.h"
#import "SaichugenTouchAppDelegate.h"
#import "SaichugenScore.h"

@implementation SaichugenTouchViewController

@synthesize startView;
@synthesize gameView;
@synthesize scoreView;
@synthesize aboutView;
@synthesize gameRuleView;
@synthesize scoreFooterView;

//----------------------------------------------------------------------
// alloc/dealloc

- (void)dealloc {
	[startView release];
	[scoreView release];
	[aboutView release];
	[gameRuleView release];
	[gameView release];
	[scoreFooterView release];
	
	[viewTransition release];
    [super dealloc];
}

//----------------------------------------------------------------------
// init

// Override initWithNibName:bundle: to load the view using a nib file 
// then perform additional customization that is not appropriate for viewDidLoad.
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        // Custom initialization
//    }
//    return self;
//}

//----------------------------------------------------------------------
// 

// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
	NSLog(@"SaichugenTouchView: loadView");
	[super loadView];
	
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	NSLog(@"SaichugenTouchView: viewDidLoad");
    [super viewDidLoad];
	
	[self.view addSubview:startView];
	viewTransition = [[ViewTransition alloc] init];
	[viewTransition setMainView:self.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

//----------------------------------------------------------------------
// Start View
- (IBAction) pressedStartButton:(id)sender {
	GameViewController* gameViewController = getDelegate().gameViewController;
	
	[gameViewController setupGame];
	[viewTransition replaceSubView:startView withNewView:gameView fromRight:NO obj:gameViewController selector:@selector(willStartGame)];
}

- (IBAction) pressedGameRuleButton:(id)sender {	
	NSString* path = [[NSBundle mainBundle] resourcePath];
	path = [path stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
	path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSLog(path);

	NSString* urlString = [NSString stringWithFormat:@"file:/%@//rule.html", path];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

	[gameRuleWebView loadRequest:request];

	[viewTransition replaceSubView:startView withNewView:gameRuleView fromRight:NO];
}

- (IBAction) pressedScoreButton:(id)sender {
	scoreTableView.dataSource = getDelegate().score;
	[scoreTableView reloadData];
	
	//
	CGRect rect = CGRectMake(0.0, 0.0, scoreTableView.bounds.size.width, scoreTableView.frame.size.height);	
	scoreFooterView.backgroundColor = [UIColor clearColor];
	scoreFooterView.frame = rect;
	scoreTableView.tableFooterView = scoreFooterView;
	
	[viewTransition replaceSubView:startView withNewView:scoreView fromRight:NO];
}

- (IBAction) pressedAboutButton:(id)sender {
	[viewTransition replaceSubView:startView withNewView:aboutView fromRight:NO];
}

//----------------------------------------------------------------------
// Game View
- (IBAction) onGameHOMEButtonPressed:(id)sender {
	[viewTransition replaceSubView:gameView withNewView:startView fromRight:YES];
}

//----------------------------------------------------------------------
// Rule View
- (IBAction) onGameRuleOKButtonPressed: (id)sender {
	[viewTransition replaceSubView:gameRuleView withNewView:startView fromRight:YES];
}

//----------------------------------------------------------------------
// Score View
- (IBAction) onScoreOKButtonPressed:(id)sender {
	[viewTransition replaceSubView:scoreView withNewView: startView fromRight:YES];
}

- (IBAction) pressedScoreResetButton:(id)sender {
	// TODO: HARD CODING!
	NSString* title = @"成績をリセット";
	NSString* msg = @"成績をリセットしますか？";
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil]; 
	[alertView show];

}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[getDelegate().score resetScore];
		[scoreTableView reloadData];
	}

	[alertView release];
}


//----------------------------------------------------------------------
// About View
- (IBAction) onAboutOKButtonPressed: (id)sender {
	[viewTransition replaceSubView:aboutView withNewView: startView fromRight:YES];
}

@end
