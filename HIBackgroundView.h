//
//  HIBackgroundView.h
//  Pods
//
//  Created by hufan on 2020/5/13.
//

#import <UIKit/UIKit.h>
#import "HIProgressViewConstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface HIBackgroundView : UIView

/**
 * The background style.
 * Defaults to MBProgressHUDBackgroundStyleBlur.
 */
@property (nonatomic) HIProgressViewBackgroundStyle style;

/**
 * The blur effect style, when using MBProgressHUDBackgroundStyleBlur.
 * Defaults to UIBlurEffectStyleLight.
 */
@property (nonatomic) UIBlurEffectStyle blurEffectStyle;

/**
 * The background color or the blur tint color.
 *
 * Defaults to nil on iOS 13 and later and
 * `[UIColor colorWithWhite:0.8f alpha:0.6f]`
 * on older systems.
 */
@property (nonatomic, strong, nullable) UIColor *color;

@end

NS_ASSUME_NONNULL_END
