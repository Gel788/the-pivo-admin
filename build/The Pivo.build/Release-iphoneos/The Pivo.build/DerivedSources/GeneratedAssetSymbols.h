#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "Logo" asset catalog image resource.
static NSString * const ACImageNameLogo AC_SWIFT_PRIVATE = @"Logo";

/// The "photo_2025-03-03%2015_10_18-no-bg-HD%20%28carve.photos%29" asset catalog image resource.
static NSString * const ACImageNamePhoto2025030320151018NoBgHD2028CarvePhotos29 AC_SWIFT_PRIVATE = @"photo_2025-03-03%2015_10_18-no-bg-HD%20%28carve.photos%29";

#undef AC_SWIFT_PRIVATE
