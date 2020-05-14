//
//  HIProgressViewConstance.h
//
//  Version 1.0.0
//  Created by hufan on 2018/11/11.
//  Copyright © 2018年 hufan. All rights reserved.
//

#ifndef HIProgressViewConstance_h
#define HIProgressViewConstance_h

extern CGFloat const HIProgressMaxOffset;

typedef NS_ENUM(NSInteger, HIProgressViewMode) {
    /// UIActivityIndicatorView.
    HIProgressViewModeIndeterminate,
    /// A round, pie-chart like, progress view.
    HIProgressViewModeDeterminate,
    /// Horizontal progress bar.
    HIProgressViewModeDeterminateHorizontalBar,
    /// Ring-shaped progress view.
    HIProgressViewModeAnnularDeterminate,
    /// Shows a custom view.
    HIProgressViewModeCustomView,
    /// Shows only labels.
    HIProgressViewModeText
};

typedef NS_ENUM(NSInteger, HIProgressViewAnimation) {
    /// Opacity animation
    HIProgressViewAnimationFade,
    /// Opacity + scale animation (zoom in when appearing zoom out when disappearing)
    HIProgressViewAnimationZoom,
    /// Opacity + scale animation (zoom out style)
    HIProgressViewAnimationZoomOut,
    /// Opacity + scale animation (zoom in style)
    HIProgressViewAnimationZoomIn
};

typedef NS_ENUM(NSInteger, HIProgressViewBackgroundStyle) {
    /// Solid color background
    HIProgressViewBackgroundStyleSolidColor,
    HIProgressViewBackgroundStyleBlur
};

typedef void (^HIProgressViewCompletionBlock)(void);

static const CGFloat HIDefaultPadding = 4.f;
static const CGFloat HIDefaultLabelFontSize = 16.f;
static const CGFloat HIDefaultDetailsLabelFontSize = 12.f;


#define HIMainThreadAssert() NSAssert([NSThread isMainThread], @"HIProgressView needs to be accessed on the main thread.");

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
        block();\
    } else {\
        dispatch_async(queue, block);\
    }
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif


#endif /* HIProgressViewConstance_h */
