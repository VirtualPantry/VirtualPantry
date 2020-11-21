# Virtual Pantry 

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The following iOS application called Virtual Pantry will automate an shopping list to the user based on the user's current inventory at the home. The application will keep track of items that are low in quantity and automatically send the item to the shopping list.

### App Evaluation
- **Category:** Productivity 
- **Mobile:** IOS application 
- **Story:** Often, many people including myself will underestimate the quanitity of their inventory when deciding to buy an food item. By having surplus of a particular item, the item will soon become expired leading to losing money and wasting food. 
- **Market:** Anyone that buys groceries for a household. 
- **Habit:** N/A 
- **Scope:** In Virtual Pantry, the user will be able to add and update an item. In addition, the iOS application must be able to automate the grocery list when an item is low on quantity

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can sign in and sign up with Google or Email/Password
* User can reset password 
* User can change password
* User can change email  
* User can view items from the pantry 
* User can view items from the grocery list 
* Add item manually to pantry 
* Add item manually to the grocery list
* Send item from grocery to pantry 
* Send item from pantry to grocery 
* Remove item from grocery list
* Remove item from pantry 
* Search for items in pantry
* Search for items in grocery 
* User can view history of items 
* User can report bugs 


**Optional Nice-to-have Stories**

* Scan the receipt and gets the sku 
* Share pantry 
* Tagging an item 
* Invite ppl to shopping list or multiple shopping list 
* Add item from scanning the barcode 
* Notifies when something is going to be bad 
* Recipes 
* Automatically sending your list to walmart pickup 

### 2. Screen Archetypes

* Login Screen
   * Users can sign in with Google or Email/Password 
* Sign up Screen
   * User can sign up with Email/Password 
* Reset Password 
   * User can reset their password 
* Change Password  
   * User can change their password 
* Change Email
   * User can change their email
* Pantry Screen 
   * User can view items from the pantry 
   * User can send item from pantry to grocery 
   * Add item manually to pantry 
* Grocery Screen
   * User can view items from the grocery list 
   * User can send item from grocery list to pantry 
   * Add item manually to grocery list 
* Settings Screen
   * Log out of the Virtual Pantry 
   * Change Email 
   * View history of items 
* Report Bugs Screen 
   * Reports bugs that occurs during the app 
* Edit Item 
   * Edit information about the item such as name, description, price
   * Add and remove items to either list 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Grocery List 
* Pantry
* Settings 

**Flow Navigation** (Screen to Screen)
* Login Screen
   * Sign up Screen 
   * Forgot Password Screen  
* Sign up Screen
   * Login Screen 
* Reset Password Screen
   * Forgot Password Screen
   * Login Screen  
* Change Password  
   * Settings Screen  
* Pantry Screen  
   * Edit Item Screen  
* Grocery Screen
   * Edit Item  
* Settings Screen
    * Change Email Screen 
    * Change Password Screen 
    * Report Bugs Screen  
* Report Bugs Screen 
   * Reports bugs that occurs during the app 
* Edit Item 
   * Pantry Screen 
   * Grocery Screen 

## Wireframes
<img src="https://github.com/VirtualPantry/VirtualPantry/blob/master/Pictures%20for%20CodePath/IMG_1228.JPG" width=600>
<img src="https://github.com/VirtualPantry/VirtualPantry/blob/master/Pictures%20for%20CodePath/IMG_1229.JPG" width=600>

### [BONUS] Digital Wireframes & Mockups
Figma - https://www.figma.com/file/VvOaIT7qwsjusrongulYWV/Wireframe-of-Virtual-Pantry-Mocks-Design?node-id=0%3A1
### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
<img src="https://github.com/VirtualPantry/VirtualPantry/blob/master/Pictures%20for%20CodePath/setDataEndpoint.PNG" width=600>
<img src="https://github.com/VirtualPantry/VirtualPantry/blob/master/Pictures%20for%20CodePath/getDataEndpoint.PNG" width=600>
