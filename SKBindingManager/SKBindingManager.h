//
//  SKBindingManager.h
//  BindableTableViewProject
//
//  Created by Slavko Krucaj on 21.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//Binding options
extern NSString *const BindingFrom;
extern NSString *const BindingTo;
extern NSString *const BindingFromKeyPath;
extern NSString *const BindingToKeyPath;
extern NSString *const BindingId;
extern NSString *const BindingTwoWayBinding;
extern NSString *const BindingForwardTransformation;
extern NSString *const BindingBackwardTransformation;
extern NSString *const BindingInitialValue;

//binding properties on views
extern NSString *const BindingPropertyLabel;
extern NSString *const BindingPropertyTextField;
extern NSString *const BindingPropertyTextView;
extern NSString *const BindingPropertySwitch;
extern NSString *const BindingPropertyStepper;
extern NSString *const BindingPropertySlider;

//binding intitial values
extern NSString *const BindingInitialValueFrom;
extern NSString *const BindingInitialValueTo;

typedef id (^SKTransformationBlock)(id value, id onObject);

@protocol SKBindingProtocol <NSObject>
@optional
- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath;
@end

@interface SKBindingManager : NSObject

@property (weak) id<SKBindingProtocol> delegate;

- (BOOL)bind:(NSDictionary *)bindingOptions;
- (void)removeAllBindings;

- (void)deactivateAllBindings;
- (void)activateAllBindings;
@end
