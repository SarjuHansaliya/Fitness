#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_7_0
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define ARTWORK_ITEM 0
#define PREVIOUS_ITEM 1
#define PLAY_ITEM 2
#define NEXT_ITEM 3
#define ADD_ITEM 4


#define MILES 1
#define CALORIES 2
#define DURATION 3

typedef enum ALARM
{
    NONE,
    AT_EVENT,
    MIN_5,
    MIN_15,
    MIN_30,
    HOUR_1,
    HOUR_2
    
}ALARM_TYPE;