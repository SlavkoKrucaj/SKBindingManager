//
//  SKBindingManager.h
//  BindableTableViewProject
//
//  Created by Slavko Krucaj on 21.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BindingFrom;
extern NSString *const BindingTo;
extern NSString *const BindingFromKeyPath;
extern NSString *const BindingToKeyPath;
extern NSString *const BindingId;
extern NSString *const BindingTwoWayBinding;
extern NSString *const BindingForwardTransformation;
extern NSString *const BindingBackwardTransformation;

extern NSString *const BindingPropertyLabel;
extern NSString *const BindingPropertyTextField;
extern NSString *const BindingPropertyTextView;
extern NSString *const BindingPropertySwitch;
extern NSString *const BindingPropertyStepper;
extern NSString *const BindingPropertySlider;

typedef id (^SKTransformationBlock)(id value, id onObject);

@protocol SKBindingProtocol <NSObject>
@optional
- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath;
@end

@interface SKBindingManager : NSObject

@property (nonatomic, assign) id<SKBindingProtocol> delegate;

- (BOOL)bind:(NSDictionary *)bindingOptions;
- (BOOL)unbind:(NSDictionary *)bindingOptions;
- (void)removeAllBindings;

@end
