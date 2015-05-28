//
//  MainWindowController.m
//  ForceClick
//
//  Created by Robert Linnemann on 5/26/15.
//  Copyright (c) 2015 Metal Toad. All rights reserved.
//

#import "MainWindowController.h"
#import "TrackingView.h"

@interface MainWindowController ()

@property (nonatomic) IBOutlet NSButton *pushButton;
@property (nonatomic) IBOutlet TrackingView *touchView;
@property (nonatomic) IBOutlet NSTextField *messageLabel;
@property (nonatomic) IBOutlet NSProgressIndicator *forceProgress;
@property (nonatomic,assign) NSInteger currentStage;

@end


@implementation MainWindowController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.touchView setWantsLayer:YES];
    [self.touchView.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
    
    self.forceProgress.maxValue = 1;
    self.forceProgress.minValue = 0;
    self.forceProgress.doubleValue = 0;

    self.currentStage = 0;
}

- (IBAction)buttonClick:(id)sender
{
    //Let's make this an 'Accelerator' button.
    NSButton *ourButton = (NSButton *)sender;
    NSLog(@"pressure: %@",@(ourButton.doubleValue));
    double normalizedVal = (ourButton.doubleValue - 1) / (2 - 1); //normalize to 0-1.
    self.forceProgress.doubleValue = normalizedVal;
}

- (IBAction)multiLevelButtonClick:(id)sender
{
    NSButton *ourButton = (NSButton *)sender;
    NSLog(@"pressure: %@",@(ourButton.doubleValue));
    double normalizedVal = (ourButton.doubleValue - 0) / (5 - 0); //normalize to 0-1.
    self.forceProgress.doubleValue = normalizedVal;
}


#pragma mark - mouse methods

- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"%@",theEvent.description);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSLog(@"%@",theEvent.description);
}

#pragma mark - pressure change event

- (void)pressureChangeWithEvent:(NSEvent *)event {
    NSLog(@"%@",event.description);
    self.forceProgress.doubleValue = event.pressure;
    if(self.currentStage != event.stage){
        self.currentStage = event.stage;
        
        if(event.stage==0){
            [self.messageLabel setStringValue:@"No Force"];
        }else if(event.stage==1) {
            [self.messageLabel setStringValue:@"Force stage 1"];
        }else if(event.stage==2) {
            [self.messageLabel setStringValue:@"Force stage 2"];
        }
    }
}


@end
