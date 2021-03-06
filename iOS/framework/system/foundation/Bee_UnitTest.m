//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "Bee_UnitTest.h"
#import "Bee_Runtime.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation BeeTestCase

+ (BOOL)runTests
{
	return YES;
}

@end

#pragma mark -

@implementation BeeUnitTest

static NSUInteger __failedCount = 0;
static NSUInteger __succeedCount = 0;

+ (BOOL)autoLoad
{
	[self runTests];

	return YES;
}

+ (NSUInteger)failedCount
{
	return __failedCount;
}

+ (NSUInteger)succeedCount
{
	return __succeedCount;
}

+ (BOOL)runTests
{
#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
	
	__failedCount = 0;
	__succeedCount = 0;

	INFO( @"Unit testing ..." );
	
	[[BeeLogger sharedInstance] indent];

	NSArray * availableClasses = [BeeRuntime allSubClassesOf:[BeeTestCase class]];
	for ( Class classType in availableClasses )
	{
		[[BeeLogger sharedInstance] disable];
		
		BOOL ret = [classType runTests];

		[[BeeLogger sharedInstance] enable];

		NSString * classTypeDesc = [classType description];
		NSString * classTypePadding = [classTypeDesc stringByPaddingToLength:48 withString:@" " startingAtIndex:0];
		
		if ( ret )
		{
			__succeedCount += 1;
			
			PRINT( [NSString stringWithFormat:@"%@\t\t\t\t[PASS]", classTypePadding] );
		}
		else
		{
			__failedCount += 1;

			PRINT( [NSString stringWithFormat:@"%@\t\t\t\t[FAIL]", classTypePadding] );
		}
	}

	INFO( @"" );
	INFO( @"Failed:  %d", __failedCount );
	INFO( @"Pass:    %.1f", (__succeedCount * 1.0f) / ((__succeedCount + __failedCount) * 1.0f) * 100 );

	[[BeeLogger sharedInstance] unindent];

	return __failedCount ? NO : YES;
	
#else	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
	
	return YES;
	
#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

#pragma mark -

TEST_CASE( BeeUnitTest )
{
	// TODO:
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
