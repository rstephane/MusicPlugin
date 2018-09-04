# Tarabia Distortion Plug in

## Description
Tarabia Distortion is a … distortion plug in effect based on two specials algorithms :
- Tarabia formula (Hard distortion), and,
- Yamaha 80’s synth soft distortion formula.

If you have a bass or synth sounds that lacks of body or lack of character… use this plug ins & you will produce a new sound full of harmonics, body & density…

## Installation
- You can try to compile it yourself,
or,
- if you don't have time neither the competencies, no worries, you can download freely the binary file from the smaolab website: http://smaolab.org/product/tarabia-distortion/

But if you are still here, I may guess that you want to compile it yourself, okay let's do it ...

### Pre requisite
The Tarabia Plug-in is made from the excellent, simple, efficient framework DPLUG:  
- Dplug has been created to develop VST/AU effects easily.
- Dplug is based on the D langage (sort of C and C++ langage).
- Dplug framework is free/libre... you can build & sell your own plugins based on this framework without paying any fees.

I think D langage is easier to learn than C++. I beleive that Dplug is simpler than Juce framework (but not as powerful as Juce). I also believe that Dplug is easier to use compared to many other langages while trying to create your own VST/AU plug-in. Of course, Dplug framework doesnot yet implement as much as functions as Juce, Faust, etc. but I found Dplug a good compromise between learning, difficulty, functions offered out of the box, the open source licence (permissive), documentation and pricing (gratuit, 0$).

### Get Started
In order to compile this program, you will need :
- Install the Dplug framework. You will find all the steps instructions here : https://github.com/AuburnSounds/Dplug/wiki/Getting-Started   

The installation process is very simple (straigthforward) but you need to follow the instructions :)

For Mac users, in this 'Getting Started', a dedicated section explains how to compile a special tool called 'Dplug-Build'. Very straigthforward but don't forget to do it.

Once you have installed DPLUG, you can pass to the next paragraph.

### Compilation
Once you have installed the Dplug framework, you will get a folder that contains several subfolders :
- One of them is called 'examples'.
- Copy the 'tarabia' folder (https://github.com/rstephane/MusicPlugin/archive/master.zip) into the 'examples' folder.
- Open a terminal window.
- Go to the subfolder 'examples/tarabia/'.

For Windows :
- Now, if you are on windows, launch the command 'dub --compiler=ldc2'
- The dub program will produce a .DLL file (which is the VST program) located in the BUILD folder.
- Copy this file into your VST effect folder and lauch your favorite DAW.
- You are done !!

For MAC :
- On MAC, to compile VST/AU plug ins, you need to use the tool 'dplug-build'. You should have installed/compiled it if you have followed the instructions from Auburn Sounds.
- Launch the command 'dplug-build --compiler ldc'.

You should get the following output :

```
info: Missing "userManualPath" in plugin.json (eg: "UserManual.pdf")
info: Missing "licensePath" in plugin.json (eg: "license.txt")
info: Missing "iconPath" in plugin.json (eg: "gfx/myIcon.png")

=> The task is to bundle plugin Tarabia Distortion from SMAOLAB.
   This plugin will be working in 64-bit.
   The choosen configurations are ["VST", "AU"].
   The choosen build type is debug.
   The choosen compiler is LDC.

*** Building configuration VST with ldc2, 64-bit arch...
$ dub build --build=debug --arch=x86_64 --compiler=ldc2 --force --config=VST
Invalid source/import path: /Users/sribas/Documents/Dplug/$VST2_SDK/pluginterfaces/vst2.x
Performing "debug" build using ldc2 for x86_64.
dplug:core 7.0.5: building configuration "library"...
dplug:carbon 7.0.5: building configuration "library"...
dplug:client 7.0.5: building configuration "library"...
dplug:cocoa 7.0.5: building configuration "library"...
dplug:au 7.0.5: building configuration "library"...
intel-intrinsics 1.0.11: building configuration "library"...
pfft 1.0.4: building configuration "library"...
dplug:dsp 7.0.5: building configuration "library"...
gfm:math 6.2.13: building configuration "library"...
dplug:graphics 7.0.5: building configuration "library"...
dplug:x11 7.0.5: building configuration "library"...
dplug:window 7.0.5: building configuration "library"...
dplug:gui 7.0.5: building configuration "library"...
dplug:flat-widgets 7.0.5: building configuration "library"...
dplug:vst 7.0.5: building configuration "library"...
tarabia ~master: building configuration "VST"...
Invalid source/import path: /Users/sribas/Documents/Dplug/$VST2_SDK/pluginterfaces/vst2.x
    => Build OK, binary size = 2.5 mb, available in ./builds/macOS-64-bit-VST

*** Generating Info.plist...
    => Generated 990 bytes.

*** Building configuration AU with ldc2, 64-bit arch...
$ dub build --build=debug --arch=x86_64 --compiler=ldc2 --force --config=AU
Invalid source/import path: /Users/sribas/Documents/Dplug/$VST2_SDK/pluginterfaces/vst2.x
Performing "debug" build using ldc2 for x86_64.
dplug:core 7.0.5: building configuration "library"...
dplug:carbon 7.0.5: building configuration "library"...
dplug:client 7.0.5: building configuration "library"...
dplug:cocoa 7.0.5: building configuration "library"...
dplug:au 7.0.5: building configuration "library"...
intel-intrinsics 1.0.11: building configuration "library"...
pfft 1.0.4: building configuration "library"...
dplug:dsp 7.0.5: building configuration "library"...
gfm:math 6.2.13: building configuration "library"...
dplug:graphics 7.0.5: building configuration "library"...
dplug:x11 7.0.5: building configuration "library"...
dplug:window 7.0.5: building configuration "library"...
dplug:gui 7.0.5: building configuration "library"...
dplug:flat-widgets 7.0.5: building configuration "library"...
dplug:vst 7.0.5: building configuration "library"...
tarabia ~master: building configuration "AU"...
Invalid source/import path: /Users/sribas/Documents/Dplug/$VST2_SDK/pluginterfaces/vst2.x
    => Build OK, binary size = 2.6 mb, available in ./builds/macOS-64-bit-AU

*** Generating Info.plist...
    => Generated 996 bytes.

*** Generating a .rsrc file for the bundle...
$ rez -arch x86_64 -o /var/folders/x2/mf7drrc5007bscfzr0fcyk1m0000gn/T/plugin.rsrc -useDF /var/folders/x2/mf7drrc5007bscfzr0fcyk1m0000gn/T/plugin.r
    => Written 540 bytes.
```

- Now, go to the subfolder '.../examples/tarabia/builds', you will find there the VST and Audio Unit compilation results.
- Copy the VST (and/or the Audio unit file) into your VST folder and launch your favorite DAW...
- Enjoy .. heu nope .. Destroy (Tarabia is a distortion plug in :) )

-- END for Mac users !

Note that you may need an internet connexion when you compile the tarabia code for the first time. Indeed, Dub (the compiler) will require to fetch some extra librairies. It will caches the libs on your local disk.

### Another example of how to create your own plug in using Dplug
- https://www.auburnsounds.com/blog/2016-02-08_Making-a-Windows-VST-plugin-with-D.html

### VST2 Steinberg Licence Agreement : IMPORTANT
- Before you make VST plugins with Dplug, you need to read and agree with the license for the VST3 SDK by Steinberg. If you don't agree with the VST SDK license, you can't make plugins with Dplug. Find the VST3 SDK there: http://www.steinberg.net/en/company/developers.html

### References on Dplug
- Github about DPLUG: https://github.com/AuburnSounds/Dplug
- Dplug documentation : http://dplug.dpldocs.info/index.html
- Blog : https://www.auburnsounds.com/blog
- Forum : https://discord.gg/QZtGZUw

### References on the D langage
- Book on D programming : http://ddili.org/ders/d.en/index.html

### Other references
- Create your own Knobs, Sliders, Vumetre ... : https://www.g200kg.com/en/webknobman/gallery.php

# Contact
If I am not clear enough, don't hesitate to drop me a mail or to post an issue :)
