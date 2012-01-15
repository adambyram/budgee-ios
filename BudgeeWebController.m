//
//  BudgeeWebController.m
//  Budgee
//
//  Created by Adam Byram on 3/2/09.
//  Copyright 2009 Adam Byram. All rights reserved.
//

#import "BudgeeWebController.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAdresses.h"


@implementation BudgeeWebController

-(id)init
{
	if(self = [super init])
	{
		self.view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BudgeeWebBackground.png"]];
		[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
		[[self navigationItem] setTitle:@"Budgee Web"];
		ipDisplay = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 320, 20)];
		ipDisplay.textColor = [UIColor whiteColor];
		ipDisplay.textAlignment = UITextAlignmentCenter;
	//	ipDisplay.text = @"123.123.123.123:8090";
		ipDisplay.backgroundColor = [UIColor clearColor];
		[self.view addSubview:ipDisplay];
		progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[progress setFrame:CGRectMake(320/2-25, 225, 50, 50)];
		[progress startAnimating];
		[self.view addSubview:progress];
		isOn = NO;
		[self viewDidLoad];
	}
	return self;
}

-(void)viewDidLoad
{
	NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAdresses performSelectorInBackground:@selector(list) withObject:nil];
	
	isOn = YES;
	[self startStopServer:self];
}


-(void)viewWillDisappear:(BOOL)animated
{
	isOn = NO;
	[self startStopServer:self];
	[super viewWillDisappear:animated];
}

-(void)dealloc
{
	[super dealloc];
}

- (void)displayInfoUpdate:(NSNotification *) notification
{
	NSLog(@"displayInfoUpdate:");
	
	if(notification)
	{
		[addresses release];
		addresses = [[[notification object] copy] retain];
		NSLog(@"addresses: %@", addresses);
	}
	if(addresses == nil)
	{
		return;
	}
	
	NSString *info;
	UInt16 port = [httpServer port];
	
	NSString *localIP = [addresses objectForKey:@"en0"];
	if (!localIP)
		info = @"No Active Wi-Fi Connection\n";
	else
		info = [NSString stringWithFormat:@"http://%@:%d", localIP, port];
	//NSString *wwwIP = [addresses objectForKey:@"www"];
	/*if (wwwIP)
		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
	else
		info = [info stringByAppendingString:@"Web: No Connection\n"];
	*/
	ipDisplay.text = info;
	[progress stopAnimating];
	[progress setHidden:YES];
	[addresses release];
}

-(BOOL)isOn
{
	return isOn;
}

- (void)startStopServer:(id)sender
{
	if ([sender isOn])
	{
		NSError *error;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
		[self displayInfoUpdate:nil];
	}
	else
	{
		[httpServer stop];
	}
}

@end
