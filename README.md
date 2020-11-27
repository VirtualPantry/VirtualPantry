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

* [x] Users can sign in and sign up with Google or Email/Password
* [x] User can reset password   
* [x] User can view items from the pantry 
* [x] User can view items from the grocery list 
* [x] Add item manually to pantry 
* [x] Add item manually to the grocery list
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
# Users
| Property | Type | Description |
| ------------- | ------------- | ------------- |
| User ID  | String  | unique ID corresponding to the user object (auto-generated) as a document |
| name  | String  | account owner's name |
| password | String | account password |
| email | String | account owner's email for login |
| groceryItems | String array | list of grocery item ID's as String |
| pantryItems | String array | list of pantry item ID's as String |
| historyItems | String array | list of history item ID's as String |

# Pantry Items
| Property | Type | Description |
| ------------- | ------------- | ------------- |
| Pantry ID  | String  | unique ID corresponding to the pantryItem object (auto-generated) as a document |
| name  | String  | pantry item's name |
| description | String | description of the pantry item |
| quantity | String | pantry item quantity |
| price | number | price of the pantry item |
| picture | String | corresponding URL to picture for pantry item |
| emergencyFlag | number | user specified number for very low quantity |
| warningFlag | number | user specified number for moderately low quantity |
| okayFlag | number | user specificed number for sufficient quantity |


# Items
| Property | Type | Description |
| ------------- | ------------- | ------------- |
| Item ID  | String  | unique ID corresponding to the Item object (auto-generated) as a document |
| name  | String  | item's name |
| picture | String | corresponding URL to picture for item |
| quantity | String | item quantity |
| price | number | price of the item |

# History Items
| Property | Type | Description |
| ------------- | ------------- | ------------- |
| History ID  | String  | unique ID corresponding to the History object (auto-generated) as a document |
| name  | String  | history item's name |
| description | String | history item's description |
| quantity | number | quantity of history item |
| picture | String | URL of picture |
| price | number | price of history item |



### Networking
  - Sign up screen
      - (Create/POST) Create a new user object 
  - Sign in screen
      - (Read/GET) Read a new user object
  - Shopping List
      - (Read/GET) Read all shopping items for a user object
      - (Update/PUT) Update selected or all shopping items and add to pantry list 
  - Pantry List
      - (Read/GET) Read all pantry items for a user object
      - (Update/PUT) Update selected or all pantry items and add to shopping list 
  - Item Information screen
      - (Update/PUT) Update viewed item 
  - History screen
     - (Read/GET) Read in the history of all items added by user 
  - Report Bug 
     - (Create/POST) Sends email about a bug to our email account 
  - Change password screen
     - (Update/PUT) Update password for the user
  - Reset password screen
     - (Update/PUT) Reset forgotten password for the user




