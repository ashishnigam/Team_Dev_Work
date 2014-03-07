//
//  Header.h
//  Sierra
//
//  Created by Ashish Nigam on 08/01/14.
//  Copyright (c) 2014 Ashish Nigam. All rights reserved.
//

#ifndef Sierra_Header_h
#define Sierra_Header_h

#ifdef UI_USER_INTERFACE_IDIOM//
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (false)
#endif

#define isIPAD() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define isIPhone() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define isPortrait() (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)||([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown))

#define isPINormal() ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
#define isPIUpsideDown() ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

#define isLandscape() (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)||([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight))

#define isLILandscapeLeft() ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)

#define isLILandscapeRight() ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)

#define isFaceUp()   ([[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp)
#define isFaceDown() ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationFaceDown)

#define isPortraitUpsideDown() ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationPortraitUpsideDown)
#define isPortraitNormal() ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationPortrait)
#define isLandscapeLeft() ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationLandscapeLeft)
#define isLandscapeRight() ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationLandscapeRight)

#define isPortraitMode() (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
#define isLandscapeMode() (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))

#define isPhone() ([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
#define isiPodCheck1() ([[UIDevice currentDevice].model isEqualToString:@"iPod touch"])
#define isiPodCheck2() (!([[UIDevice currentDevice].model isEqualToString:@"iPhone"] || [[UIDevice currentDevice].model isEqualToString:@"iPad"]))

#define isIOS7() (([[NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] intValue] >= 7) && ([[NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] intValue] < 8))

#define isIOS6() (([[NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] intValue] >= 6) && ([[NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] intValue] < 7))

#define isIOS5() (([[NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] intValue] >= 5) && ([[NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] intValue] < 6))

#define isIOSGreaterThan7() ([[NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] intValue] >= 7)


#define runningOSIsEqualOrGreaterThan(version) (([[[UIDevice currentDevice] systemVersion] compare:reqSysVer options:NSNumericSearch] == NSOrderedDescending) || ([[[UIDevice currentDevice] systemVersion] compare:reqSysVer options:NSNumericSearch] == NSOrderedSame))

#endif
