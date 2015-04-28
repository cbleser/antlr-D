/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. All rights reserved

        license:        BSD style: $(LICENSE)
        
        version:        Sep 2007: Initial release
        version:        Nov 2007: Added stream wrappers

        author:         Kris
        modified by:    Carsten Bleser Rasmussen to fit with ANTLR
                        ANTLR is ported from java and java has 16bit char type.
                        The Format Module is copied from tango.text.convert.Format
                        and the char type is changed to dchar instead of char

*******************************************************************************/

module antlr.tango.Format;

private import tango.text.convert.Layout;

/******************************************************************************

        Constructs a global utf8 instance of Layout

******************************************************************************/


template Format(char_t) {
  char_t[] Format (char_t[] formatStr, ...)
  {
	return format!(char_t).format(_arguments, _argptr, formatStr);
  }
  //
}

template format(char_t) {
  static public Layout!(char_t) format;
  static this()
  {
  	format = Layout!(char_t).instance;
  }
}

