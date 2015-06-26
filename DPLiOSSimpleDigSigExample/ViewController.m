//
//  ViewController.m
//  DPLiOSSimpleDigSigExample
//
//  Created by Kevin Newman on 2015/06/23.
//  Copyright (c) 2015 Debenu (Pty) Ltd. All rights reserved.
//

#import "ViewController.h"
#import "DebenuPDFLibraryCPiOSObjC1115.h"

@interface ViewController ()
@property (nonatomic, weak) UILabel *StatusLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Create PDF and sign" forState:UIControlStateNormal];
    [button sizeToFit];
    
    // Get the screen size
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    
    // Set the button to half the screen width
    button.center = CGPointMake(screenWidth / 2, 60);
    
    // Link the button click to the buttonPressed event handler
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Create a label for status information
    UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, screenWidth, 40)];
    self.StatusLabel = theLabel;
    [self.view addSubview:theLabel];
}

- (void)buttonPressed:(UIButton *)button {
    
    // Create the Debenu PDF Library object
    DebenuPDFLibraryCPiOSObjC1115 *DPL = [DebenuPDFLibraryCPiOSObjC1115 new];
    
    // Unlock the library
    if ([DPL UnlockKey:@"... your license key here ..."] == 1)
    {
        // Draw some text on the page
        [DPL DrawText:100:700:@"Hello world"];

        // Save the PDF to a byte array
        NSData *PDFData = [DPL SaveToString];
        
        // Set up the signing process, sign the PDF stored in the byte array
        int signProcess = [DPL NewSignProcessFromString:PDFData:@""];
        
        // Get the file name of the certificate stored in the app bundle
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *PFXFileName = [mainBundle pathForResource: @"bobsmith" ofType: @"pfx"];
        
        // Set the digital identity certificate and password for the PFX
        [DPL SetSignProcessPFXFromFile:signProcess:PFXFileName:@"test123"];
        
        // Set the page number and signature field position
        [DPL SetSignProcessFieldPage:signProcess:1];
        [DPL SetSignProcessFieldBounds:signProcess:100:700:200:200];
        
        // Set the name for the signature field
        [DPL SetSignProcessField:signProcess:@"SignatureField001"];
        
        // Set the signing information
        [DPL SetSignProcessInfo:signProcess:@"Reason for signing":@"Location":@"Contact info"];
        
        // Get the app's Documents folder
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString  *outputFile = [documentsDirectory stringByAppendingPathComponent:@"Signed Document.pdf"];
        
        // Run the digital signature process, saving the result to an output file
        [DPL EndSignProcessToFile:signProcess:outputFile];
        
        // Get the sign process result and release the sign process
        int SignProcResult = [DPL GetSignProcessResult:signProcess];
        [DPL ReleaseSignProcess:signProcess];
        
        // Display the signature success/failure to the user
        if (SignProcResult == 1)
        {
            self.StatusLabel.text = @"Signature okay";
        }
        else
        {
            self.StatusLabel.text = [NSString stringWithFormat:@"Signature failed: %i", SignProcResult];
        }
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
