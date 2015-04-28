/**
 * Support Traits for runtime ANTLR
 *
 * Authors:   Carsten Bleser Rasmussen
 */
module antlr.runtime.misc.Traits;

private import tango.core.Traits;

template isAtomic2Type(T) {
    const isAtomic2Type = isAtomicType!(MutableOf!T);
}

/** This template finds the const type of T if T implicitly can be converted into a const type and can be hold in variable HolderOf without making a explicit copy or dup.
    This template can be used on an argument of template functions if the argument is kept constant.
    The called argument can be const,immutable or variable.
    Ex.
    class TClass(T) {
    HolderOf! T value;
    void func(ConstOf!T x) {
    value=x;
    }
    }
    ...
    The function "func" can be called with.
    auto C=new Tclass!(char[]);
    char[] str;
    const(char[]) const_str="Const";
    immutable(char[]) immutable_str="Immutable";
    C.func(str);
    C.func(const_str);
    C.func(immutable_str);
*/

template ConstOf(T) {
    static if (is(T U:const(U)[])) {
	alias const(U)[] ConstOf;
    } else static if (is(T U:const(U))) {
            alias const(U) ConstOf;
        } else {
            alias T ConstOf;
        }
}

template HolderOf(T) {
    static if (is(T U==immutable(U[]))) {
	// pragma(msg, "inside is(T U==immutable(U)[])  U="~U.stringof~" MutableOf!U="~MutableOf!(U).stringof);
	alias const(MutableOf!U)[] HolderOf;
    } else static if(is(T U:U[])) {
            // pragma(msg, "inside T="~T.stringof~"  is(T U:U[])"~U.stringof);
            static if (is(U S==const(S))) {
                // pragma(msg, "inside is(U S==const(S)) U="~U.stringof~" S="~S.stringof);
                alias U[] HolderOf;
            } else static if (is(U S==immutable(S))) {
                    // pragma(msg, "inside is(U S==immutable(S)) U="~U.stringof~" S="~S.stringof)
                    ;
                    alias const(S)[] HolderOf;
                } else
                    alias HolderOf!(U)[] HolderOf;
        } else static if (is(T U==const(U))) {
            // pragma(msg, "inside is(T U==const(U)) U="~U.stringof);
            static if (isAtomicType!(MutableOf!T)) {
                alias U HolderOf;
            } else {
		alias T HolderOf;
            }
        } else static if (is(T U==immutable(U))) {
            static if (isAtomicType!(MutableOf!T)) {
                alias U HolderOf;
            } else {
		alias const(U) HolderOf;
            }
        } else {
            alias T HolderOf;
	}
}

/** Converts a type to a mutable type
 */
template MutableOf(T) {
    static if(is(T U:const(U)[]))
        alias MutableOf!(U)[] MutableOf;
    else static if(is(T U:const(U)))
             alias U MutableOf;
        else
        alias T MutableOf;
}

template ImmutableOf(T) {
  static if(is(T U:immutable(U)[]))
    alias ImmutableOf!(U)[] MutableOf;
  else static if(is(T U:immutable(U)))
    alias U ImmutableOf;
  else
    alias T ImmutableOf;
}

unittest {
    import tango.io.Stdout;
    class TemplateClass(T) {
	HolderOf!T value;

	bool equal(ConstOf!T val) const {
            return val==value;
	}

	T set(ConstOf!T val) {
            value=cast(HolderOf!T)val;
            return value;
	}

    }

    struct TestStruct {
	int x,y;
	real z;
	this(const int x, const int y, const real z)  {
            this.x=x;this.y=y;this.z=z;
	}
    }

    class TestClass {
	int x,y;
	real z;
	this() {
            z=1.0;
	}
	this(const int x, const int y, const real z) {
            this.x=x;this.y=y;this.z=z;
	}
    }

    // Implicitly conversion
    static assert(is(const(int) : int));
    static assert(is(immutable(int) : int));
    static assert(is(const(Object)==const Object));
    static assert(is(int[] :const(int)[]));
    static assert(is(immutable(int)[] :const(int)[]));
    static assert(is(const(int)[] :const(int)[]));
    static assert(is(const(int[]) :const(int)[]));
    static assert(is(immutable(int[]) :const(int)[]));
    static assert(is(immutable(int[]) :immutable(int)[]));
    static assert(is(immutable(int[])  : const(int)[]));
    static assert(is(immutable(int[][])  : const(int[])[]));
    static assert(is(immutable(int[][][])  : const(int[][])[]));

    // Atomics common
    static assert(is(ConstOf!(int)==const(int)));
    static assert(is(ConstOf!(immutable int)==const(int)));
    static assert(is(ConstOf!(const(int))==const(int)));
    // Object common
    static assert(is(ConstOf!(Object)==const(Object)));
    static assert(is(ConstOf!(immutable(Object))==const(Object)));
    static assert(is(ConstOf!(const(Object))==const Object ));
    // Atomics Array common
    static assert(is(ConstOf!(int[]) == const(int)[]) );
    static assert(is(ConstOf!(const(int)[]) == const(int)[]) );
    static assert(is(ConstOf!(immutable(int)[]) == const(int)[]) );
    // Fixed Atomics Array common
    static assert(is(ConstOf!(const(int[])) == const(int)[]) );
    static assert(is(ConstOf!(immutable(int[])) == const(int)[]) );
    // Object Array common
    static assert(is(ConstOf!(Object[]) == const(Object)[]) );
    static assert(is(ConstOf!(const(Object)[]) == const(Object)[]) );
    static assert(is(ConstOf!(immutable(Object)[]) == const(Object)[]) );
    // Fixed Object Array common
    static assert(is(ConstOf!(const(int[])) == const(int)[]) );
    static assert(is(ConstOf!(immutable(int[])) == const(int)[]) );
    // Jaggles common
    static assert(is(ConstOf!(int[][]) == const(int[])[]));
    static assert(is(ConstOf!(const(int[])[]) == const(int[])[]));
    static assert(is(ConstOf!(const(int[][])) == const(int[])[]));
    static assert(is(ConstOf!(immutable(int[])[]) == const(immutable(int)[])[]));
    static assert(is(ConstOf!(immutable(int[][])) == const(immutable(int)[])[]));

    // Atomics Mutable
    static assert(is(MutableOf!(int)==int));
    static assert(is(MutableOf!(const(int))==int));
    static assert(is(MutableOf!(immutable(int))==int));
    // Object Mutable
    static assert(is(MutableOf!(Object)==Object));
    static assert(is(MutableOf!(const(Object))==Object));
    static assert(is(MutableOf!(immutable(Object))==Object));
    // Array Mutable
    static assert(is(MutableOf!(int[])==int[]));
    static assert(is(MutableOf!(const(int[]))==int[]));
    static assert(is(MutableOf!(immutable(int[]))==int[]));
    static assert(is(MutableOf!(const(int)[])==int[]));
    static assert(is(MutableOf!(immutable(int)[])==int[]));
    // Jaggle Mutable
    static assert(is(MutableOf!(int[][])==int[][]));
    static assert(is(MutableOf!(const(int[][]))==int[][]));
    static assert(is(MutableOf!(immutable(int[][]))==int[][]));
    static assert(is(MutableOf!(const(int[])[])==int[][]));
    static assert(is(MutableOf!(immutable(int[])[])==int[][]));
    static assert(is(MutableOf!(const(int[][][]))==int[][][]));
    static assert(is(MutableOf!(immutable(int[][][]))==int[][][]));

    // Atomic Holder
    pragma(msg, HolderOf!(int).stringof);
    pragma(msg, HolderOf!(const(int)).stringof);
    static assert(is(HolderOf!(int)==int));
    static assert(is(HolderOf!(const(int))==int));
    static assert(is(HolderOf!(immutable(int))==int));
    static assert(is(int : HolderOf!(int)));
    static assert(is(const(int) : HolderOf!(const(int))));
    static assert(is(immutable(int) : HolderOf!(immutable(int))));
    // Object Holder
    static assert(is(HolderOf!(Object)==Object));
    static assert(is(HolderOf!(const(Object))==const(Object)));
    static assert(is(HolderOf!(immutable(Object))==const(Object)));
    static assert(is(Object : HolderOf!(Object)));
    static assert(is(const(Object) : HolderOf!(const(Object))));
    static assert(is(immutable(Object) : HolderOf!(immutable(Object))));
    // Atomic Array Holder
    static assert(is(HolderOf!(int[])==int[]));
    static assert(is(HolderOf!(const(int)[])== const(int)[]));
    static assert(is(HolderOf!(immutable(int)[])==const(int)[]));
    static assert(is(int[] : HolderOf!(int[])));
    static assert(is(const(int)[] : HolderOf!(const(int)[])));
    static assert(is(immutable(int)[] : HolderOf!(immutable(int)[])));
    // Atomic Fixed Array holder
    static assert(is(HolderOf!(const(int[]))== const(int)[]));
    static assert(is(HolderOf!(immutable(int[]))==const(int)[]));
    static assert(is(const(int[]) : HolderOf!(const(int[]))));
    static assert(is(immutable(int[]) : HolderOf!(immutable(int[]))));
    // Object Array holder
    static assert(is(HolderOf!(Object[])==Object[]));
    static assert(is(HolderOf!(const(Object)[])==const(Object)[]));
    static assert(is(HolderOf!(immutable(Object)[])==const(Object)[]));
    static assert(is(Object[] : HolderOf!(Object[])));
    static assert(is(const(Object)[] : HolderOf!(const(Object)[])));
    static assert(is(immutable(Object)[] : HolderOf!(immutable(Object)[])));
    // Object Fixed Array holder
    static assert(is(HolderOf!(const(Object[]))== const(Object)[]));
    static assert(is(HolderOf!(immutable(Object[]))==const(Object)[]));
    static assert(is(const(Object[]) : HolderOf!(const(Object[]))));
    static assert(is(immutable(Object[]) : HolderOf!(immutable(Object[]))));
    // Jaggle Holder
    static assert(is(HolderOf!(int[][]) == int[][]));
    static assert(is(HolderOf!(const(int[])[]) == const(int[])[]));
    static assert(is(HolderOf!(immutable(int[])[]) == const(int[])[]));
    static assert(is(immutable(int[])[] : HolderOf!(immutable(int[])[])));
    static assert(is(HolderOf!(immutable(int[][])[]) == const(int[][])[]));
    static assert(is(immutable(int[][])[] : HolderOf!(immutable(int[][])[])));
    static assert(is(HolderOf!(immutable(int[][][])) == const(int[][])[]));
    static assert(is(immutable(int[][][]) : HolderOf!(immutable(int[][])[])));


    Stdout("Runtime test").nl;
    // Runtime test
    auto temp_int=new TemplateClass!(int);
    auto temp_struct=new TemplateClass!(TestStruct);
    auto temp_class=new TemplateClass!(TestClass);
    auto temp_string=new TemplateClass!(char[]);
    auto temp_class_array=new TemplateClass!(TestClass[]);
    Stdout("After test").nl;
    // Atomics
    auto y1=temp_int.set(10);
    assert(temp_int.equal(10));
    assert(temp_int.equal(y1));
    int x2=30;
    auto y2=temp_int.set(x2);
    assert(temp_int.equal(20));
    assert(temp_int.equal(x2));
    // Struct
    auto x3=TestStruct(20,40,1.0);
    auto y3=temp_struct.set(x3);
    assert(temp_struct.equal(y3));
    assert(temp_struct.equal(const(TestStruct)(20,40,1.0)));

//    assert(temp_struct.equal(immutable(TestStruct)(20,40,1.0)));
    // const Struct
    auto x4=const(TestStruct)(30,40,2.2);
    auto y4=temp_struct.set(x4);
    assert(temp_struct.equal(y4));
    assert(temp_struct.equal(const(TestStruct)(20,40,1.0)));
//    assert(temp_struct.equal(immutable(TestStruct)(20,40,1.0)));
    // Array
    char[] x5="Test".dup;
    auto y5=temp_string.set(x5);
    assert(temp_string.equal(y5));
    assert(temp_string.equal(cast(const(char)[])("Test")));
    assert(temp_string.equal("Test"));

    auto x6=new TestClass(20,40,1.0);
    auto y6=temp_class.equal(x6);
    auto x7=new TestClass[10];
    auto y7=temp_class_array.equal(x7);
    static assert(is(ConstOf!(char[])==const(char)[]));
    static assert(is(ConstOf!(immutable(char)[])==const(char)[]));
    static assert(is(ConstOf!(immutable(char)[])==const(char)[]));
    static assert(is(MutableOf!(char[])==char[]));
    static assert(is(MutableOf!(immutable(char)[])==char[]));
    static assert(is(MutableOf!(immutable(char)[])==char[]));
    Stdout("Eof Traits").nl;
}

// ------- CTFE -------

/// compile time integer to string
char [] ctfe_i2a(int i){
    char[] digit="0123456789".dup;
    char[] res="".dup;
    if (i==0){
        return "0".dup;
    }
    bool neg=false;
    if (i<0){
        neg=true;
        i=-i;
    }
    while (i>0) {
        res=digit[i%10]~res;
        i/=10;
    }
    if (neg)
        return '-'~res;
    else
        return res;
}
