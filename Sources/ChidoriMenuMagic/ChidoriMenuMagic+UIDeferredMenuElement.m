//
//  ChidoriMenuMagic+UIDeferredMenuElement.m
//  ChidoriMenu
//
//  Created by 秋星桥 on 6/23/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#ifdef DEBUG
#define ChidoriDebugAssert(condition, description) NSAssert(condition, description);
#else
#define ChidoriDebugAssert(condition, description) ;
#endif

/*

 As of iOS 26, -[UIDeferredMenuElement elementProvider] was removed
 We need to hook the initializer to save the provider.
 
*/

static char kElementProviderKey;

// Function pointers to store original implementations
static IMP original_elementWithProvider_IMP = NULL;
static IMP original_elementWithUncachedProvider_IMP = NULL;

@implementation NSObject (ChidoriMenuMagic_UIDeferredMenuElement)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Hook UIDeferredMenuElement class methods
        Class deferredMenuElementClass = NSClassFromString(@"UIDeferredMenuElement");
        ChidoriDebugAssert(deferredMenuElementClass != nil, @"UIDeferredMenuElement class not found");
        if (!deferredMenuElementClass) {
            return;
        }
        
        // Add elementProvider instance method if it doesn't exist
        SEL elementProviderSelector = NSSelectorFromString(@"elementProvider");
        if ([deferredMenuElementClass instancesRespondToSelector:elementProviderSelector]) {
            // Method already exists, no need to hook
            return;
        }
        
        // Add the elementProvider method dynamically
        class_addMethod(deferredMenuElementClass, 
                      elementProviderSelector, 
                      (IMP)chidori_elementProvider, 
                      "@@:");
        
        // Hook elementWithProvider:
        Method originalElementWithProvider = class_getClassMethod(deferredMenuElementClass, 
                                                                @selector(elementWithProvider:));
        if (originalElementWithProvider) {
            original_elementWithProvider_IMP = method_getImplementation(originalElementWithProvider);
            method_setImplementation(originalElementWithProvider, 
                                   (IMP)chidori_elementWithProvider);
        }
        
        // Hook elementWithUncachedProvider: (iOS 15.0+)
        SEL uncachedProviderSelector = NSSelectorFromString(@"elementWithUncachedProvider:");
        Method originalElementWithUncachedProvider = class_getClassMethod(deferredMenuElementClass, 
                                                                         uncachedProviderSelector);
        if (originalElementWithUncachedProvider) {
            original_elementWithUncachedProvider_IMP = method_getImplementation(originalElementWithUncachedProvider);
            method_setImplementation(originalElementWithUncachedProvider, 
                                   (IMP)chidori_elementWithUncachedProvider);
        }
    });
}

// Custom elementProvider getter implementation
static id chidori_elementProvider(id self, SEL _cmd) {
    id provider = objc_getAssociatedObject(self, &kElementProviderKey);
    return provider;
}

// Hook for elementWithProvider:
static id chidori_elementWithProvider(Class cls, SEL _cmd, id elementProvider) {
    // Call original implementation
    typedef id (*OriginalIMP)(Class, SEL, id);
    OriginalIMP originalIMP = (OriginalIMP)original_elementWithProvider_IMP;
    id element = originalIMP(cls, _cmd, elementProvider);
    
    // Store the provider block using associated objects
    if (element && elementProvider) {
        // Copy the block to ensure it's retained properly
        id copiedProvider = [elementProvider copy];
        objc_setAssociatedObject(element, &kElementProviderKey, copiedProvider, OBJC_ASSOCIATION_RETAIN);
    }
    
    return element;
}

// Hook for elementWithUncachedProvider:
static id chidori_elementWithUncachedProvider(Class cls, SEL _cmd, id elementProvider) {
    // Call original implementation
    typedef id (*OriginalIMP)(Class, SEL, id);
    OriginalIMP originalIMP = (OriginalIMP)original_elementWithUncachedProvider_IMP;
    id element = originalIMP(cls, _cmd, elementProvider);
    
    // Store the provider block using associated objects
    if (element && elementProvider) {
        // Copy the block to ensure it's retained properly
        id copiedProvider = [elementProvider copy];
        objc_setAssociatedObject(element, &kElementProviderKey, copiedProvider, OBJC_ASSOCIATION_RETAIN);
    }
    
    return element;
}

@end


