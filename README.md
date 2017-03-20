TBX
===

TBX is an add-on package for Toolbar2000 components: http://www.jrsoftware.org/tb2k.php.

TBX expands Toolbar2000 with the following new features:

* Support for native themes and Windows visual styles
* Customizable layout for toolbar items
* Variations of font size for toolbar items
* Multi-line captions
* Combo and list boxes
* Dockable panels (task panes)
* Tool palettes and color selectors
* A status bar component
* Additional controls


Compatibility
-------------

Compatible with Delphi/C++Builder 4–XE5.


Installation
------------

Uninstall previous versions of Toolbar2000 and TBX from your IDE.

Download [Toolbar2000 2.2.2](http://www.jrsoftware.org/tb2k.php)
and unzip it somewhere on your hard drive.  
Unzip TBX, compile *Tools\TB2k Patch*, run it and patch Toolbar2000 directory.

Install Toolbar2000 to your IDE: add *Toolbar2000\Source* directory to your
IDE options, then open and compile *Toolbar2000\Packages\tb2k_dxx.dpk*, open and install
*Toolbar2000\Packages\tb2kdsgn_dxx.dpk* (xx is your Delphi version).

Install TBX to your IDE: add *TBX\Source*, *TBX\Source\Themes* and *TBX\Source\rmkThemes*
(optionally) to your IDE options, then open and compile *TBX_Dxx.dpk*, open and install
*TBX_Dxx_Design.dpk* (xx is your Delphi version).


Credits
-------

Alex A. Denisov, initial developer.  
Roy Magne Klever (http://rmklever.com), contributor.  
Robert Lee (http://www.silverpointdevelopment.com), contributor.  
Vladimir Bochkarev (boxa@mail.ru), contributor.  
Alexander Klimov (schwarzkopf-m@yandex.ru), contributor.  
Yury Plashenkov (https://github.com/plashenkov), contributor and current maintainer.
