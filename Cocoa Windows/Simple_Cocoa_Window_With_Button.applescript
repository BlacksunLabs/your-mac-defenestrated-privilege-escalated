(*
 * Hyper simplistic PoC pure-Cocoa title-less window with working button.
 * Intended as a basic template for futher customization
 * 
 * Coded by https://github.com/n0ncetonic
 * 
 * Copyright © 2018 Blacksun Labs
   
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

property NSRect : class "NSRect"
property NSWindow : class "NSWindow" of current application

global mainWindow, winRect

(*
 * 
 *)
on makeWindow()
	set winRect to {{666, 666}, {666, 666}}
	(* 
	 * Set styleMask to 1 when development complete to remove close button
	 * otherwise you will have no way to close the window if your
	 * button handler code is broken
	 *)
	set mainWindow to NSWindow's alloc()'s initWithContentRect:winRect styleMask:3 backing:2 defer:false
	
	(*
	 * closeBtnFrame creates the box that will hold a button that
	 * when clicked will invoke the closeBtn handler. 
	 * 
	 * A tell block is used to set the closeBtn's properties. Most
	 * important are the Target and Action properties which allow
	 * the button to trigger a handler when clicked.
	 *
	 * Finally we add closeBtn into mainWindow's view, and instruct
	 * mainWindow to render as the current display's front-most window
	 *)
	set closeBtnFrame to current application's NSMakeRect(300, 300, 100, 50)
	set closeBtn to current application's NSButton's alloc's initWithFrame:closeBtnFrame
	tell closeBtn
		set its bezelStyle to 12
		its setTitle:"Blacksun Labs"
		its setButtonType:0
		its setTarget:me
		its setAction:"closeBtn:"
	end tell
	mainWindow's contentView's addSubview:closeBtn
	
	mainWindow's makeKeyAndOrderFront:me
end makeWindow

on closeBtn:sender
	mainWindow's orderOut:sender
end closeBtn:

makeWindow()
