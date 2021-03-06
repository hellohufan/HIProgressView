//
//  HIViewController.m
//  HIProgressView
//
//  Created by hellohufan on 05/13/2020.
//  Copyright (c) 2020 hellohufan. All rights reserved.
//

#import "HIViewController.h"
#import "HIExample.h"
#import "HIProgressManager.h"
#import "HIProgressView.h"

@interface HIViewController ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSArray<NSArray<HIExample *> *> *examples;

@property (atomic, assign) BOOL canceled;

@end

@implementation HIViewController

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.examples =
    @[@[[HIExample exampleWithTitle:@"简洁接口" selector:@selector(easyShow)],
        [HIExample exampleWithTitle:@"简洁菊花模式" selector:@selector(indeterminateExample)],
        [HIExample exampleWithTitle:@"带文字的菊花模式" selector:@selector(labelExample)],
        [HIExample exampleWithTitle:@"带文字详情的菊花模式" selector:@selector(detailsLabelExample)]],
      @[[HIExample exampleWithTitle:@"圆圈内圈进度条模式" selector:@selector(determinateExample)],
        [HIExample exampleWithTitle:@"圆圈进度条模式" selector:@selector(annularDeterminateExample)],
        [HIExample exampleWithTitle:@"条形进度条模式" selector:@selector(barDeterminateExample)]],
      @[[HIExample exampleWithTitle:@"文字提醒Bottom" selector:@selector(textExample)],
        [HIExample exampleWithTitle:@"文字提醒Center" selector:@selector(customViewExample)],
        [HIExample exampleWithTitle:@"带取消按钮的圆圈进度条" selector:@selector(cancelationExample)],
        [HIExample exampleWithTitle:@"准备-加载-clean-完成" selector:@selector(modeSwitchingExample)]],
      @[[HIExample exampleWithTitle:@"On window" selector:@selector(windowExample)],
        [HIExample exampleWithTitle:@"NSURLSession" selector:@selector(networkingExample)],
        [HIExample exampleWithTitle:@"Determinate with NSProgress" selector:@selector(determinateNSProgressExample)],
        [HIExample exampleWithTitle:@"暗黑背景菊花" selector:@selector(dimBackgroundExample)],
        [HIExample exampleWithTitle:@"colors菊花" selector:@selector(colorExample)]]
      ];
}

#pragma mark - Examples

- (void)easyShow {
    [HIProgressManager show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do something useful in the background
        [self doSomeWork];
        //显示和隐藏必须在主线程调用
        dispatch_async(dispatch_get_main_queue(), ^{
            [HIProgressManager hide];
        });
    });
}
- (void)indeterminateExample {
    
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];
    [hud setAnimationType:HIProgressViewAnimationZoomOut];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do something useful in the background
        [self doSomeWork];
        //显示和隐藏必须在主线程调用
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)labelExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Set the label text.
    hud.label.text = @"加载中...";
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)detailsLabelExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Set the label text.
    hud.label.text = @"加载中...";
    // Set the details label text. Let's make it multiline this time.
    hud.detailsLabel.text = NSLocalizedString(@"Parsing data\n(1/1)", @"HUD title");

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)windowExample {
    // Covers the entire screen. Similar to using the root view controller view.
    HIProgressView *hud = [HIProgressManager showOn:self.view.window animated:YES];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)determinateExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Set the determinate mode to show task progress.
    hud.mode = HIProgressViewModeDeterminate;
    hud.label.text = @"加载中...";

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)determinateNSProgressExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = HIProgressViewModeDeterminate;
    hud.label.text = @"加载中...";

    // Set up NSProgress
    NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
    hud.progressObject = progressObject;

    // Configure a cancel button.
    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:progressObject action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgressObject:progressObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)annularDeterminateExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Set the annular determinate mode to show task progress.
    hud.mode = HIProgressViewModeAnnularDeterminate;
    hud.label.text = @"加载中...";

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)barDeterminateExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Set the bar determinate mode to show task progress.
    hud.mode = HIProgressViewModeDeterminateHorizontalBar;
    hud.label.text = @"加载中...";

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)customViewExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Set the custom view mode to show any view.
    hud.mode = HIProgressViewModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = @"完成";

    [hud hideAnimated:YES afterDelay:3.f];
}

- (void)textExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    hud.mode = HIProgressViewModeText;
    hud.label.text = NSLocalizedString(@"Message here!", @"HUD message title");
    
    hud.offset = CGPointMake(0.f, -40.f);

    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)cancelationExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    hud.mode = HIProgressViewModeDeterminate;
    hud.label.text = @"加载中...";

    [hud.button setTitle:@"取消" forState:UIControlStateNormal];
    [hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)modeSwitchingExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];
    hud.label.text = @"准备中...";
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithMixedProgress:hud];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)networkingExample {
    HIProgressView *pv = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Set some text to show the initial status.
    pv.label.text = @"准备...";
    
    pv.minSize = CGSizeMake(150.f, 100.f);
    [self doSomeNetworkWorkWithProgress:pv];
}

- (void)dimBackgroundExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];

    // Change the background view style and color.
//    hud.backgroundView.style = HIProgressViewBackgroundStyleSolidColor;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)colorExample {
    HIProgressView *hud = [HIProgressManager showOn:self.navigationController.view animated:YES];
    hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];

    // Set the label text.
    hud.label.text = @"加载中...";

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

#pragma mark - Tasks

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(1.);
}

- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
    // This just increases the progress indicator in a loop.
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) break;
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(20000);
    }
}

- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [HIProgressManager progressViewFromMotherView:self.navigationController.view].progress = progress;
        });
        usleep(20000);
    }
}

- (void)doSomeWorkWithMixedProgress:(HIProgressView *)hud {
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = HIProgressViewModeDeterminate;
        hud.label.text = @"加载中...";
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(20000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = HIProgressViewModeIndeterminate;
        hud.label.text = @"清理中...";
    });
    sleep(2);
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = HIProgressViewModeCustomView;
        hud.label.text = @"完成";
    });
    sleep(2);
}

- (void)cancelWork:(id)sender {
    self.canceled = YES;
}

- (void)doSomeNetworkWorkWithProgress:(HIProgressView *)pv {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
    [task resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //do somthing
    dispatch_async(dispatch_get_main_queue(), ^{
        HIProgressView *hud = [HIProgressManager progressViewFromMotherView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = HIProgressViewModeCustomView;
        hud.label.text = @"完成";
        [hud hideAnimated:YES afterDelay:3.f];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;

    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        HIProgressView *hud = [HIProgressManager progressViewFromMotherView:self.navigationController.view];
        hud.mode = HIProgressViewModeIndeterminate;
        hud.progress = progress;
    });
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examples.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HIExample *example = self.examples[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HIExampleCell" forIndexPath:indexPath];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [cell.textLabel.textColor colorWithAlphaComponent:0.1f];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HIExample *example = self.examples[indexPath.section][indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.selector];
#pragma clang diagnostic pop

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}


@end
