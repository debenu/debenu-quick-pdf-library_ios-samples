//
//  ViewController.m
//  DPLiOSSimpleRenderExample
//
//  Created by Kevin Newman on 2015/06/18.
//  Copyright (c) 2015 Debenu (Pty) Ltd. All rights reserved.
//

#import "ViewController.h"
#import "DebenuPDFLibraryCPiOSObjC1115.h"

@interface ViewController ()
@property (nonatomic, weak) UIImageView *PDFView;
@property (nonatomic, weak) UILabel *StatusLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Create PDF and render" forState:UIControlStateNormal];
    [button sizeToFit];
    
    // Get the screen size
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    // Set the button to half the screen width
    button.center = CGPointMake(screenWidth / 2, 60);
    
    // Link the button click to the buttonPressed event handler
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Create a label for status information
    UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, screenWidth, 40)];
    self.StatusLabel = theLabel;
    [self.view addSubview:theLabel];
    
    // Create a view to display the PDF page
    UIImageView *theView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 160, screenWidth, screenHeight - 160)];
    self.PDFView = theView;
    [self.view addSubview:theView];
}

- (void)buttonPressed:(UIButton *)button {
    
    // Create the Debenu PDF Library object
    DebenuPDFLibraryCPiOSObjC1115 *DPL = [DebenuPDFLibraryCPiOSObjC1115 new];
    
    // Unlock the library
    if ([DPL UnlockKey:@"... your license key ..."] == 1)
    {
        // Draw a line diagonally across the page
        [DPL SetLineColor:1:0:0];
        [DPL SetLineWidth:5];
        [DPL DrawLine:0:[DPL PageHeight]:[DPL PageWidth]:0];
        
        // Draw a red box in each corner
        [DPL SetFillColor:0:1:0];
        [DPL DrawBox:0:10:10:10:1];
        [DPL DrawBox:[DPL PageWidth] - 10:10:10:10:1];
        [DPL DrawBox:0:[DPL PageHeight]:10:10:1];
        [DPL DrawBox:[DPL PageWidth] - 10:[DPL PageHeight]:10:10:1];
        
        // Render the page into an byte array
        NSData* renderedPage = [DPL RenderPageToString:300:1:1];
        
        // Load the image from the byte array
        UIImage *PDFimage = [UIImage imageWithData:renderedPage];
        
        // Set the image as the view contents
        self.PDFView.contentMode = UIViewContentModeScaleAspectFit;
        [self.PDFView setImage:PDFimage];
    }
    else
    {
        self.StatusLabel.text = @"UnlockKey failed, check DPL license key";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
