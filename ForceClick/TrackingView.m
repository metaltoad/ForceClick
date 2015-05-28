//
//  TrackingView.m
//  ForceClick
//
//  Created by Robert Linnemann on 5/26/15.
//  Copyright (c) 2015 Metal Toad. All rights reserved.
//

#import "TrackingView.h"
#import <QuartzCore/QuartzCore.h>

@interface TrackingView()
@property (nonatomic) NSTrackingArea *trackingArea;

@property (nonatomic,assign) BOOL mouseInArea;
@property (nonatomic,assign) float currentPressure;
@property (nonatomic,assign) NSPoint currentPoint;
@property (nonatomic,assign) NSInteger stage;
@end

@implementation TrackingView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.mouseInArea = NO;
        [self createTrackingArea];
        self.currentPressure = 0.0f;
        self.stage = 0; //0 is nothing or end of touch, 1 is normal click, 2 is force click.
        
        //boilerplate
        self.wantsLayer = YES;
        self.layer = [self makeBackingLayer];
        [self.layer setDelegate:self];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if(self.mouseInArea){
        NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        [gc saveGraphicsState];
        [[NSColor whiteColor] setStroke];
        [[NSColor whiteColor] setFill];

        // Create our circle path, min size for no pressure.
        int circleSide = (self.currentPressure <= 0) ? 10 : self.currentPressure*100;
        int x = self.currentPoint.x - (circleSide/2);
        int y = self.currentPoint.y - (circleSide/2);
        NSRect rect = NSMakeRect(x, y, circleSide, circleSide);
        
        NSBezierPath* circlePath = [NSBezierPath bezierPath];
        [circlePath appendBezierPathWithOvalInRect: rect];
        
        [circlePath stroke];
        [circlePath fill];
        
        [gc restoreGraphicsState];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    NSLog(@"entered");
    self.mouseInArea = YES;
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"%@,%@",@(self.currentPoint.x),@(self.currentPoint.y));
//    self.stage = theEvent.stage;
    [self setNeedsDisplay:YES];

}

- (void)mouseMoved:(NSEvent *)theEvent {
    self.currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"%@,%@",@(self.currentPoint.x),@(self.currentPoint.y));
    [self setNeedsDisplay:YES]; //triggers drawRect:
}

- (void)mouseExited:(NSEvent *)theEvent {
    NSLog(@"exited");
    self.mouseInArea = NO;
    [self setNeedsDisplay:YES]; //triggers drawRect:
}

- (void)pressureChangeWithEvent:(NSEvent *)event {
    [super pressureChangeWithEvent:event]; //pass this up the responder chain.
    self.currentPressure = event.pressure;    //get current pressure.
    [self setNeedsDisplay:YES];

}


- (void)createTrackingArea {
        if(self.trackingArea != nil) {
            [self removeTrackingArea:self.trackingArea];
        }
        
        int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved);
        self.trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                     options:opts
                                                       owner:self
                                                    userInfo:nil];
        [self addTrackingArea:self.trackingArea];
}


@end
