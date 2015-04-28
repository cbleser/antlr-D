# antlr-D
ANTLR runtime for D-lang.
This code contain is translation of the ANTLR-runtime into D2.


Porting
------
### Strings
Tango uses char array's instead for String class like in Java.
Because Tango-D supports three string types based on char, wchar and dchar
this library use template types call char_t which can be set to
(char, wchar or dhcar)

### Object
I have tried to avoid the class Object because D support template types
which makes the code more readable and easier to maintain.
The code uses less type casting than the Java version without Templates.
In some case I have used Variant instead of Object.


### Runtime linking
D doesn't directly support runtime linking like in Java
and I decided not to try to build runtime linking because
it is difficult to debug an maintain.
Instead I used delegate, template types/classes and Variant.

History
-------
This library has been in use since 2008-2009 in D1 version and has been ported to between different version of Tango, ANTLR and D compilers.

I haven't published this code before because of all those moving targets. But now the changes on Tango, ANTLR3 and D2 seams to settle.


ANTLR
--------
For now it support ANTLR 3.3 and I am slowly working on support of ANTLR-3.5

Installing
---------

This runtime library is base on Tango-D2 but it only works we my branch of this library for now.
I am working on get the modification to Tango into the main branch of Tango-D2.

This means that you need to clone my versions of Tango-D2.

Choose a install directory $INSTALL

    cd $INSTALL

Clone the testing branch into the directory tango

    git clone -b testing --single-branch https://github.com/cbleser/Tango-D2.git tango

Install the runtime

    git clone https://github.com/cbleser/antlr-D.git

Compiling
---------
First you need to compile the tango library.

    cd tango
    make all

Note. If you want to use a specific compiler (I use dmd-2.064.2) you can do this by.

    make DC=dmd-2.064.2 MODEL=64 all

Compiling the ANTLR-runtime

If you need to build a special version of antlr which includes support for D2 you do this as follows

    cd antld-D
    make

The antlrd is now installed in antlr-D/antlrlib

You can now compile the antlr/runtime

    cd antlr/runtime
    make DC=dmd-2.064.2 all

In the directory antlr-D/antlr/runtime/tests you have some grammar samples for testing.
You can compile and run those samples by.

    cd tests
    make run


StringTemplate
--------------
I also have a version of StringTemplate but this is not maintained. But if somebody want to work with it I can update load it to github.
