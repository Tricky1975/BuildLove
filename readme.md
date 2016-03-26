# BuildLove


I set up this quick tool in order to quickly set up my LOVE2D projects.
I always set up tons of "libraries" that will be used in multiple programs of mine, and this builder seeks them out and builds my project with it. I can also make sure that if certain things should only happen on a specific platform, it will only happen on that platform, this thanks to the simple pre-processor.


In order to set this builder up, download the source code and use [BlitzMAX](http://www.blitzmax.com) to compile it. Please note the code *MUST* be compiled in *CONSOLE MODE*. In GUI mode the tool won't work well. In order to compile you may need some stuff from my TrickyMods repository.
I may every now and then put some pre-compiled builds in the release section, however, keep in mind they are always behind (the windows and linux versions in particular).

When reporting bugs always check if the version you have is up-to-date with the code versions in this repository. The way I version number them is based on the Ubuntu version numbering system. YY.MM.DD


Before you start using the tool (either after compiling it yourself) you need to put an .ini file in the same directory as where you keep the executable binary.
For Mac this file should be named: BuildLove.Mac.ini
For Windows this file should be named: BuildLove.Windows.ini
For Linux this file should be named: BuilLove.Linux.ini

Put the next heading into it: 
~~~
[List:LIBRARIES]
~~~
And on the lines below that, just type all the directory names (in full path names) where you store libraries in of this tool.


Now Libraries can be placed in either one of these directories or in your project.
There are two ways of stories Libraries. Either you create a file named <mylibrary>.lua or you name it <mylibrary>.lll/<mylibrary>.lua

In the latter case, Linux users must keep in mind the case sensitive nature of Linux, and I therefore recommend to only use lower case. 
I also need to note that the builder does not support unicode filenames, so only use letters, numbers and _ if you want to be sure no odd behavior will turn up.




Now if you start a project, make sure it contains one "iloveyou.lua" file. Even on Linux the use of lower case or upper case does not matter, and it may live in ANY folder you desire within your project, as long as it's not your external libraries. This file serves as your main file. I know that Love2D uses main.lua itself, and that is exactly why you cannot use it, as the builder will create that file itself with some extra functionality in it.



Lastly here are the pre-processor commands.
They must all be prefixed with "-- *", this is in order not to spook up syntax highlighters, or editors with automated parse error detectors.

The pre-processor supports the next commands:

~~~lua
-- *import <library>
~~~
Imports a library. Just enter the final name alone without pathnames or extentions. Pathnames are allowed with internal files you import but without extentions. So "-- *import mylib.lua" is not good "-- *import mylib" is correct.
If the library you imported is external the builder will automatically copy it into your project and also if that library has library calls of its own it will also import those. External libraries that are not called at all will be ignored.

~~~lua
-- *define <tag>
~~~
Adds a tag to the definition list. This command only takes effect for the file in which this command is preset. It will not affect any parent files or imported files.

~~~lua
-- *undef <tag>
~~~
Removes a tag previously set up with -- *define or a global tag present in the project main file. It will not affect any parent files or imported files.


~~~lua
-- *if <tag1> [<tag2> [<tag3> [<tag4>.....]]]
~~~
if all tags are found all lines until either the next -- *if or the next -- *fi will be added, otherwise they'll be ignored.
Nice to know, the builder does support the internal tags $MAC, $WINDOWS, $LINUX, $ANDROID and $IOS which are automatically added when building stuff for that specific platform.

If you prefix a tag with "!" the tag may not be present. Oh yeah, this command works in the "AND" manner.

~~~lua
-- *fi
~~~
Just ends the -- *if statement set up before.




Then the pre-processor will replace the next tags with the applicable data. This works as well INSIDE as OUTSIDE strings, however in most cases I do recommend to use them INSIDE a string, unless you know what you are doing.
(The tags below are all CASE SENSITIVE).

 Tag | Data |
==== | ==== |
 $$mydir$$ | will turn into the directory in which the lua file itself lives. This is most of all done to make your life easier when creating libraries. |


And that should be it. Enjoy!

