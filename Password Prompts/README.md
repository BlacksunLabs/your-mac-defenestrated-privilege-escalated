# File Descriptions
- Dialog_Box_CompositeIcon_Basic.applescript
	- Takes the `display dialog` payload everyone uses and takes it up a notch with a much more believeable icon handled in memory because dropping a static icon to disk is just silly.

- NSAlert_Textbox_Accessory_View.applescript
	- Conceptually FuzzyNop's baby, he asked if we couldn't make his client-side phishing much more realistic. During my Post-Defcon funemployment idle hands got the best of me.
	- Leverages the "accessory view" property of NSAlert dialogs to add username and password labled inputs and a composited icon to standard system alert dialog.
	- NSAlert does the heavy lifting of creating a Cocoa window so our payload is much smaller and just has to focus on creating a handful of Cocoa objects.
	- NSAlert also handles text styling so we get the same bolded message and standard subtext that is impossible via `display dialog`.
	- Now that everyone and their mother, and empire, has used `display dialog` to death and detection of `display dialog` is trivial, I wanted more. No `display dialog`, standard invocation and use of a core system class, no external libraries, and begging for the astute to modify the code for running directly from the command-line without the need to compile to .app.
	- Not so secretly can't wait to see how many malware families start using this technique vs `display dialog`

	# Building NSAlert_Textbox_Accessory_View.app
	
	1. _Open_ NSAlert_Textbox_Accessory_View.app in *Script Editor*
	2. _Click_ *Export* in the *File* menu
	3. _Select_ *Application* from the _File Format_ dropdown
	4. _Check_ the *Run-only* Option
	5. _Click_ the *Save* button

	No need to code sign because aint nobody got time for that