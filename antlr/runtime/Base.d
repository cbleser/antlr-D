module antlr.runtime.Base;

template Base(T) {
  T max(T a, T b) {
    return (a>b)?a:b;
  }
  T min(T a, T b) {
    return (a<b)?a:b;
  }
}

template Bits() {
  char[] toString(BitSet bits) {
    char[] result="0b";
    foreach(bit; bits) {
      result~=bit?'1':'0';
    }
    return result;
  }
}


