module antlr.runtime.misc.Format;

import tango.text.convert.Layout;
import tango.text.convert.Format;


static assert(wchar.sizeof == 2);
static assert(dchar.sizeof == 4);

public static Layout!(char) Format8;
public static Layout!(wchar) Format16;
public static Layout!(dchar) Format32;

static this() {
        Format8 = Layout!(char).instance;
        Format16 = Layout!(wchar).instance;
        Format32 = Layout!(dchar).instance;
}

immutable(char)[] iFormat8(T ...)(T t) {
    return Format8(t).idup;
}

immutable(wchar)[] iFormat16(T ...)(T t) {
    return Format16(cast(const(wchar)[])t[0], t[1..$]).idup;
}

immutable(dchar)[] iFormat32(T ...)(T t) {
    return Format32(cast(const(dchar)[])t[0], t[1..$]).idup;
}

template iFormatT(char_t) {
    static if (is(char_t == char)) {
        alias iFormat=iFormat8;
    }
    static if (is(char_t == wchar)) {
        alias iFormat=iFormat16;
    }
    static if (is(char_t == dchar)) {
        alias iFormat=iFormat32;
    }
}