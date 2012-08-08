<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link type="text/css" rel="stylesheet" media="screen" href="./style.css">

#Code conventions
*Alterplay 2012*

###Table of contents

1. [Overview](#overview)
1. [Classes](#classes)
1. [Methods](#methods)
1. [Variables](#variables)
1. [Constants](#constants)
1. [Indentation](#indentation)
1. [Code nesting](#code-nesting)
1. [Literals](#literals)

<h2 id="overview">1. Overview</h2>

This Code Conventions (CC) document contains standard conventions that we at Alterplay follow and recommend that others follow.
It covers filenames, file organization, indentation, comments, declarations, statements, white space, naming conventions, programming practices and includes some code examples.

###1.1. Some reasons for following conventions
* 80% of the lifetime cost of a piece of software goes to maintenance.
* Hardly any software is maintained for its whole life by the original author.
* Code conventions improve the readability of the software, allowing engineers to understand new code more quickly and thoroughly.
* You will forget why you've wrote this awesome line with variable `superVar` probably in 2 weeks.

###1.2. Rules

There are some cases that are not yet covered within this document. Remember these rules:

1. Respect your colleagues but keep in mind that they are less smart than you. Always simplify. Write comments when code is not transparent.

1. Pay attention how Xcode generates code, how Apple SDK examples are done, when Xcode does automatic code formatting etc. We're in Apple's ecosystem and playing by their rules will save us time later.

1. Keep with the code style and conventions of the project (if there are any). If you take a project someone is developing for more than couple of weeks - don't rewrite everything, just be humble and follow their style.

###1.3. Links to read

* Cocoa Style for Objective-C by Scott Stevenson ([part one][part_one], [part two][part_two]).

[part_one]: http://cocoadevcentral.com/articles/000082.php
[part_two]: http://cocoadevcentral.com/articles/000083.php

<h2 id="classes">2. Classes</h2>

Classes are the main and usually the only block type for building your application.

1. Class name should be as short as possible. Use only real english words. Use only `CamelCaseForNamingYourClasses`. Class name should be capitalized.

1. Class name should consist of two main parts: *function* + *type*. For example, if I have a farm class that raises pigs I will name my class `PigRaisingFarm`. If a short name like `PigFarm` makes sense then you can use the short one. Some examples for most used class types:
	* `Article` &mdash; entity class for model.
	* `ArticleListViewController` &mdash; UIViewController subclass for managing list of Article entities.
	* `ArticleViewController` &mdash; UIViewController subclass for viewing Article entity.
	* `ArticleManager` &mdash; a DAO (data access object) for Article entities.
	* `ArticleView` &mdash; UIView subclass for displaying Article entity information.

1. If your class is included in a shared repository/library add a prefix to it's name because Objective-C doesn't support namespaces.

1. If you create a subclass for standard UIKit's class to customize it &mdash; for example, a subclass of UINavigationController, you should name it `<MyProject>NavigationController`, where **\<MyProject\>** should be replaced by your project name. 

###2.1. Header file (\*.h)

Header file is a public interface to your class. Design it as if you're creating an opensource library.

1. Class declaration example:
		
		//
		//  MyClass.h
		//  Project
		//
		//  Class description.
		//
		//  Created by Author on 10/25/11.
		//  Copyright (c) 2012 Company. All rights reserved.
		//

		@interface MyClass : NSObject

		@property (strong, nonatomic) id myVar;
		@property (assign, nonatomic) NSUInteger myInteger;

		@property (strong, nonatomic) UILabel *myLabel;
	
		/**
		 * Method comment. Markdown is welcomed.
		 */
		- (void)doSomething;

		@end

1. Only public stuff should be placed in \*.h file. To create private class ivars, properties, methods place your private code in an `@interface` block in \*.m file.

1. Combine similar class variables and methods to groups with an optional comment as a title. It will make your code more readable and clean. For example:

		///-----
		/// Data
		///-----
		@property (nonatomic, retain) NSString *entityName;
		@property (nonatomic, retain) NSManagedObjectContext *moc;
		
		///----------------
		/// Creating entity
		///----------------
		- (id)create;
		- (id)createWithDictionary:(NSDictionary *)dictionary;
		
		///----------------
		/// Updating entity
		///----------------
		- (void)updateEntity:(id)entity fromDictionary:(NSDictionary *)dictionary;
		- (void)updateEntity:(id)entity fieldName:(NSString *)fieldName fromDictionary:(NSDictionary *)dictionary byKey:(NSString *)key;
		
	Such strange comments are useful for generation [appledoc](http://gentlebytes.com/appledoc/), which is used widely by open source developers.

1. Write descriptive comments for your class. They should be placed at the line "Class description." (before the declaration).

###2.2. Body file (\*.m)

1. Class body example:

		//
		//  MyClass.m
		//  Project
		//
		//  Created by Author on 10/25/11.
		//  Copyright (c) 2012 Company. All rights reserved.
		//
		
		#import "MyClass.h"
		
		@interface MyClass

		@end

		@implementation MyClass
		
		#pragma mark - Object lifecycle
		
		- (id)init
		{
			...	
		}

1. Constructors start with the `- (id)init…` prefix (in case you didn't know). 

1. Static constructors start with `- (id)entity…` prefix. For example, for class named `City` static constructor name with city title initializing will be `+ (id)cityWithTitle:(NSString *)title`.

1. Using data accessors (getters and setters) with the `self.` prefix is **strongly recommended** and should be preferred in every case except those when you need direct ivar access.

1. Combine similar class variables and methods to groups with a title in format `#pragma mark - Group title`. Example:

		#pragma mark - Entity description
		
		- (id)entityDescription
		{
		    return [NSEntityDescription …];
		}
		
		#pragma mark - Creating entity
		
		- (id)create
		{
			return [NSEntityDescription …];
		}
		
		#pragma mark - Updating entity
		
		- (void)updateEntity:(id)entity fromDictionary:(NSDictionary *)dictionary
		{
		    …
		}
		
		- (void)updateEntity:(id)entity fieldName:(NSString *)fieldName fromDictionary:(NSDictionary *)dictionary byKey:(NSString *)key
		{
			…
		}

1. If you need to declare private ivars, properties, methods, you can do this in an `@interface` block before `@implementation`, for example:

		@interface MyClass ()

		@property (…) bool mySecretVar;

		@end

		@implementation
		…

<h2 id="methods">Methods</h2>

> Developers do much more reading of code than writing, so Objective-C and Cocoa are designed to read well.

1. You should choose a method name based on **how it will look in actual use**. Let's say I want to write an in-memory file object written to disk. In some languages, that would look like this:

		fileWrapper.write(path, true, true);

	In Cocoa/Objective-C, it looks like this:

		[fileWrapper writeToFile:path atomically:YES updateFilenames:YES];

	When creating a method, ask yourself if its behavior will be clear from its name alone, particularly when surrounded by tens of thousands of lines of code.

	Reading a message as a phrase is a good way to test your method name:

		// Open the file with this application and deactivate
		[finder openFile:mailing withApplication:@"MailDrop" andDeactivate:YES];

	This message is sent to NSWorkspace (aka Finder), and it clearly passes the "phrase" test.

1. Last point permits you creating very long method names so you should not follow this fanatically. Be wise.

1. Don't use the **get** prefix on simple accessors. Instance variables and methods can have the same name, so use this to your advantage:

		- (NSString *)name;
		- (NSString *)color;
		
		name = [object name];
		color = [object color];

1. Use the **set** prefix on setters, for example:

		[object setName:name];
		[object setColor:color];

1. Place comments to your methods in the header file, for example:

		/**
		 * Awesome method to make complex decisions
		 */
		- (void)decide;
		
	Such strange comments are useful for generation [appledoc](http://gentlebytes.com/appledoc/), which is used widely by open source developers.

<h2 id="variables">Variables</h2>

1. Variable names are written CamelCase, but start with a lowerCaseLetter:

		NSString *streetAddress = @"1 Infinite Loop";
		NSString *cityName = @"Cupertino";

1. You should always make a space between class name and a *:

		NSString *myVar;  // Correct
		NSString * myVar; // Incorrect
		NSString* myVar;  // Incorrect

1. You should choose clear, distinct variable names over terse ones. Ambiguity frequently results in bugs, so be explicit.

	* Correct

			NSString *hostName;
			NSNumber *ipAddress;
			NSArray *accounts;

	* Incorrect

			NSString *HST_NM; // All caps and too terse
			NSNumber *theip;  // Is it a word or abbreviation?
			NSMutableArray *nsma; // Completely ambiguous

<h2 id="constants">Constants</h2>

1. Constants should be named all caps with underscore as a word delimiter, for example: `MY_FAVORITE_CONST`.

1. It is better to declare constants as preprocessor commands with `#define` block:

		#define MY_CONSTANT @"MyConstant"
		#define SIZE_HEIGHT 200.0f

1. Another way is creating static `NSString` variables:
	* in your `@interface` block:
			
			extern NSString * const MY_FAVORITE_CONST;

	* in your `@implementation` block:
			
			NSString * const MY_FAVORITE_CONST = @"My favorite const value";

<h2 id="indentation">Indentation</h2>

1. Use tabs indentation. This will make possible for other developers to setup as big indent as he wants without modifying any code.

1. Each nested block of code should be indented with one tab relatively to its parent. For example:

		for (...) {
			if (...) {
		        initialized = YES;
				if (...) {
					settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[self filePath]];
				} else {
					settings = [[NSMutableDictionary alloc] init];
				}
			}
		}

1. Format your code in first 100 symbol columns so other developer with 1280x768 screen can view it comfortably. Set page guide at column 100.

1. If method you're using is very long, it is recommended to separate it's params with returns. For example:

		- (void)fetchDaysForCategoryId:(NSUInteger)categoryId withParams:(NSDictionary *)params andFilters:(NSDictionary *)filters success:(void(^)())success failure:(void(^)())failure;
		
	This one looks a bit messy. Better way:

		- (void)fetchDaysForCategoryId:(NSUInteger)categoryId 
		                    withParams:(NSDictionary *)params 
		                    andFilters:(NSDictionary *)filters 
		                       success:(void(^)())success
		                       failure:(void(^)())failure;
	
	In use:
	
		[myObject
		 fetchDaysForCategoryId:1
		 withParams:params
		 andFilters:filters
		 success:nil
		 failure:^{
		 	NSLog(@"Error.");
		 }];
		 
<h2 id="code-nesting">Code nesting</h2>

1. Methods are recommended to write this way:

		-(void)myMethod
		{
			…
		}
		
	This is how Xcode autocompletes it.
	
1. Nested code blocks should be written this way:

		if (something) {
			[self doSomething];
			switch (type) {
				case 1:
					NSLog(@"1");
					break;
			}
		}

1. Write brackets even if you have only 1 line of nested code:

		- (void)myMethod
		{
			if (self.error) {
				return;
			}
		}
	
	Following this rule you will produce cleaner code and will simplify editing when someone decides to add one more line of code.

<h2 id="literals">Literals</h2>

1. Float values should be written in this way:

		float foo = 1.0f;
		float bar = 0.0f;
		
	This way won't lead you to inaccuracy errors by type conversion fault. Besides this is how Apple writes float values in it's source code.