# SKBindingManager - lightweight bindings for iOS

`SKBindingManager` is component which allows you to easily add bindings to your code with support for ARC. 

It is designed so you can bind two objects or UIViews, or any other combination of those two. Basic purpose of this component is to enable binding between models and Views without having to write a lot of unnecessary code which handels everything.

`SKBindingManager` allows you to dynamically add or remove bindings. You can specify wheather you would like one-way or two-way binding. It has an integrated support for cycle detection in your bindings. For instance if you have object `A` with properties `a`, `b` and `c`. You will not be allowed to make bindings like this `A.a -> A.b -> A.c -> A.a` because that would cause bindings to refresh themselves indefinetly. You can also define specific transformations you want to do before for instance `A.a` refreshes object `A.b` via blocks.

##Supported objects for binding

Bindings are supported for any kind of user defined `NSObject` subclasses and in `UIKit` for `UILabel`, `UITextField`, `UITextView`, `UISwitch` and `UISlider`. But you can add support for custom `UIView` objects.

##Examples

When you clone project and open it in XCode, you have folder `SimpleExample` which contains code which is explained here in basic usage. You also have folder `ComplexExample` which is a demonstration of abilities of `SKBindingManager`.

##Basic usage of SKBindingManager

To use SKBindingManager just drag and drop `SKBindingManager.h` and `SKBindingManager.m` to your project.

Usually (most cases) you will make a property on your `UIViewController`, but if you need to you can define it in any subclass of `NSObject`. So create instance like this:
```objective-c
self.bindingManager = [[SKBindingManager alloc] init];
```
Now you have binding manager which will take care of all bindings you add to it. So lets bind `UITextView` to property `name` of some random `Person` model. You would do it like this.
```objective-c
self.person = [[Person alloc] init];

//create binding options dictionary which contains all properties needed for binding
NSMutableDictionary *bindingOptions = [NSMutableDictionary dictionary];

//set binding id for this connection
[bindingOptions setObject:@"name.textFieldText" forKey:kBindingOptionBindId];

//set object and propety - from 
[bindingOptions setObject:self.person forKey:kBindingOptionFromObject];
[bindingOptions setObject:@"name" forKey:kBindingOptionFromKeyPath];

//set object and property - to
[bindingOptions setObject:self.textField forKey:kBindingOptionToObject];
[bindingOptions setObject:kBindingTextViewObservableProperty forKey:kBindingOptionToKeyPath];

//specify if you want two-way or one-way binding
[bindingOptions setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];

//add binding
[self.bindingManager bind:bindingOptions];
```
 
Afer this, your textField is binded to name property of Person. Whenever you change one of those two the other will update.

###Transformations

Let say that whenever you type name into textField you want to add string `@"12345"` to the end of the name. To do this you would just need to add option to your dictionary like this
```objective-c
SKTransformationBlock transformation = ^(id value, id toObject) { 
	NSString *name = (NSString *)value;
	return [name stringByAppendingString:@"12345"];
};

//set transformation as backward because it goes from 'to object' to 'from object'
[bindingOptions setObject:transformation forKey:kBindingOptionBackwardTransformation];
```
###Delegation

If you want to be notified when some object has been changed you just have to implement protocol `SKBindingProtocol` and whenever the change on some object occurs `- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath;` will be called. First you set yourself to be a delegate `self.bindingManager.delegate = self` and then you implement method something like this
```objective-c
- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath {
   	if ([object isEqual:self.textField]) {
   		NSLog(@"Text field has been changed");
   	} else {
   		NSLog(@"Persons name has been changed");
   	}
   	
   	NSLog(@"TextField.text = %@ and Person.name = %@", self.textField.text, self.person.name);
}
```
###Custom objects

If you want to add binding support to your custom `UIView` object you have to do few steps. Your custom object has to implement `SKBindingProtocol` and it has to have some observable property. From your custom object you would have to update observableProperty when some custom change occurs. When you do that you can just bind that observableProperty to something else. 

For examples check `SKPickerView` or `SKTableVeiw`, subclasses of `UIPickerView` and `UITableView` which have observable properties for binding.