This code contain is translation of the ANTLR-runtime and ANTLR-StringTemplate
into D.

Strings
Tango uses char array's instead for String class like in Java.
Becuase Tango-D supports three char type char,wchar and dchar
this library use template types call char_t which can be set to 
(char,wchar or dhcar)

Object
I have tried to avoid the class Object because D support template types
which makes the code more readable and easier to maintain. 
The code uses less type casting than the Java version.
In some case I have used Variant instead of Object.


Runtime linking
D doesn't directly support runtime linking like in Java
and I decided not to try to build runtime linking because 
it is difficuit to debug an maintain.
Instead I used delegate, template types/classes and Variant.  
