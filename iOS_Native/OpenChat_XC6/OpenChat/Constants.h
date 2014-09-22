//
//  Constants.h
//  OpenChat
//
//  Created by Ashish Nigam on 22/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#ifndef OpenChat_Constants_h
#define OpenChat_Constants_h

//========================================================================
//Functional Macros
#define USE_FONT_NAME_WITH_SIZE(fontName,fontSize)\
[UIFont fontWithName:fontName size:fontSize]

#define USE_FONT_DESCRIPTOR_WITH_SIZE(fontDescriptor,fontSize)\
[UIFont fontWithDescriptor:fontDescriptor size:fontSize]

#define FONT_NAMES_FROM_FONT_FAMILY(fontFamilyName)\
[UIFont fontNamesForFamilyName:fontFamilyName]

//========================================================================
//========================================================================


//Constant Screen/Controller vise

// Chat Screen (Live FaeTime View Controller).
#define CHAT_SCREEN_USER_OTHER_AVATAR_IMG @"BlueJIcon.png"
#define CHAT_SCREEN_USER_ME_AVATAR_IMG @"me.png"

#endif
