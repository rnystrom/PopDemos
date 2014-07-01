//
//  RWTCurtainController.m
//  PopDemos
//
//  Created by Ryan Nystrom on 6/30/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "RWTCurtainController.h"
#import <POP.h>
#import <BCMeshTransformView.h>
#import "BCMeshTransform+DemoTransforms.h"

@interface RWTCurtainController ()
<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet BCMeshTransformView *transformView;
@property (nonatomic, assign, getter = isOpen) BOOL open;

// helper property to aid our animation
@property (nonatomic, assign) CGPoint curtainOpenPoint;

@end

@implementation RWTCurtainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // code used from BCMeshTransformView demo
    // https://github.com/Ciechan/BCMeshTransformView
    
    UIView *container = [[UIView alloc] initWithFrame:self.transformView.bounds];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    container.backgroundColor = [UIColor colorWithRed:0.85 green:0.25 blue:0.27 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:container.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = @"Tap the curtain...";
    label.font = [UIFont systemFontOfSize:30.0];
    [container addSubview:label];
    
    [self.transformView.contentView addSubview:container];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/2000.0;
    
    // 3d properties
    self.transformView.supplementaryTransform = perspective;
    self.transformView.diffuseLightFactor = 0.5;
    
    // init to open
    [self setIdleTransform];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.transformView addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    spring.springBounciness = 10;
    spring.springSpeed = 10;
    
    POPAnimatableProperty *property = [POPAnimatableProperty propertyWithName:@"curtainOpenPoint" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(RWTCurtainController *vc, CGFloat values[]) {
            CGPoint point = vc.curtainOpenPoint;
            values[0] = point.x;
            values[1] = point.y;
        };
        
        prop.writeBlock = ^(RWTCurtainController *vc, const CGFloat values[]) {
            vc.transformView.meshTransform = [BCMutableMeshTransform curtainMeshTransformAtPoint:CGPointMake(values[0], values[1]) boundsSize:vc.view.bounds.size];
        };
        
        prop.threshold = 0.01;
    }];
    
    spring.property = property;
    
    CGRect bounds = self.view.bounds;
    CGPoint closedPoint = CGPointMake(CGRectGetWidth(bounds), CGRectGetMidY(bounds));
    CGPoint openPoint = CGPointMake(100, CGRectGetMidY(bounds));

    if (self.isOpen) {
        spring.fromValue = [NSValue valueWithCGPoint:openPoint];
        spring.toValue = [NSValue valueWithCGPoint:closedPoint];
    }
    else {
        spring.toValue = [NSValue valueWithCGPoint:openPoint];
        spring.fromValue = [NSValue valueWithCGPoint:closedPoint];
    }
    
    self.open = ! self.isOpen;
    
    [self pop_addAnimation:spring forKey:@"spring"];
}

- (void)setIdleTransform {
    self.transformView.meshTransform = [BCMutableMeshTransform curtainMeshTransformAtPoint:CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height/2.0)
                                                                                boundsSize:self.transformView.bounds.size];
}

@end
