//
//  UIViewController+Swizzling.m
//  Videoky
//
//  Created by Ricardo Maqueda on 05/10/14.
//  Copyright (c) 2014 Ricardo Maqueda. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(swizzled_viewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling
- (void)swizzled_viewDidLoad {
    NSString *className = [NSString stringWithFormat:@"%@", self.class];
    if ([className containsString:@"MOL"]) {
        if ([className rangeOfString:@"UIAlert"].location == NSNotFound) {
            NSLog(@"************************ viewDidLoad : %-35s ************************", className.UTF8String);
        }
    }

    [self swizzled_viewDidLoad];
}

@end
