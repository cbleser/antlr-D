module antlr.runtime.misc.MinMax;


auto min(T1,T2)(T1 a, T2 b) {
    static if (is(T1 : T2)) {
        return (a < b)?cast(T2)a:b;
    } else static if (is(T2 : T1)) {
        return (a < b)?a:cast(T1)b;
    } else {
        pragma(msg, "Type "~T1.stringof~" and "~T2.stringof~" is incompatible");
    }
}

auto max(T1,T2)(T1 a, T2 b) {
    return min(b, a);
}