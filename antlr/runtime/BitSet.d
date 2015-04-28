/*
  [The "BSD licence"]
  Copyright (c) 2005-2008 Terence Parr
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
  3. The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
module antlr.runtime.BitSet;

//import java.util.List;
//import tango.core.BitArray;
import tango.io.Stdout;
// import tango.io.device.Array;
// import tango.io.stream.Text;
import tango.math.Math;
import tango.text.Text;

/**A stripped-down version of org.antlr.misc.BitSet that is just
 * good enough to handle runtime requirements such as FOLLOW sets
 * for automatic error recovery.
 */
struct BitSet {
    private ulong[] words;
    enum int bits_per_word = ulong.sizeof*8;    // number of bits /
                                               // ulong
    enum ulong bits_word_mask = bits_per_word-1;

    // Check the shift operator of 64bits
    static assert((1UL << 31) == 0x0000_0000_8000_0000UL);
    static assert((1UL << 32) == 0x0000_0001_0000_0000UL);
    static assert((1UL << 63) == 0x8000_0000_0000_0000UL);

    static final ulong bitshift(ulong pos) {
        return (1UL << (pos & (bits_per_word-1)));
    }

    static assert(bitshift(31) == 0x0000_0000_8000_0000UL);
    static assert(bitshift(32) == 0x0000_0001_0000_0000UL);
    static assert(bitshift(63) == 0x8000_0000_0000_0000UL);

    private size_t bitlen;


    /* We will often need to do a mod operator (i mod nbits).  Its
     * turns out that, for powers of two, this mod operation is
     * same as (i & (nbits-1)).  Since mod is slow, we use a
     * precomputed mod mask to do the mod instead.
     */
    //protected final static int MOD_MASK = bits_per_word - 1;

    /** The actual data bits */
    //    protected ulong bits[];

    /** Construct a bitset of size one word (64 bits) */
    //     public this() {
    //         this(bits_per_word);
    //     }

    /** Construction from a static array of ulongs */
    //     public this(ulong[] bits) {
    // 	  this.bits.init(cast(void[])bits, bits.sizeof*8);
    //     }

    // public static const BitSet opCall(const(ulong)[] bits) {
    //     BitSet result;
    //     result.bits.init(bits.dup, bits.length*ulong.sizeof*8);
    //     return result;
    // }


    // this(this) {

    // }

    public BitSet opCall(const(ulong)[]bits)  {
        words=bits.dup;
        bitlen=bits.length*bits_per_word;
        return this;
    }

    this(const(ulong)[] bits) {
        words=bits.dup;
        bitlen=bits.length*bits_per_word;
    }

    // this(this) {
    //     words=this.words;
    //     bitlen=this.bitlen;
    //     assert(bitlen>0);
    // }
    // BitSet opAssign(const BitSet rhs) {
    //     words=rhs.words.dup;
    //     bitlen=rhs.bitlen;
    //     return this;
    // }
   // this(this) {

    // }
   // public BitSet opAssign(const(ulong)[]bits) {
    //     return this.opCall(bits);
    // }

    unittest {
        BitSet a=[0x0001_2000_0000_01A0UL];
        BitSet b=[0x0000_2000_0000_0000UL];;
        b[5]=b[7]=b[8]=true;
        b[45]=b[48]=true;
        a.length=b.length;
        assert(a.length == b.length);
        assert(a.words == b.words);
        assert(a==b);
        // Empty BitSet
        auto empty=BitSet([]);
        assert(!empty[1]);
        b[100]=true;
        assert(b.words.length==(100 / bits_per_word)+1);
    }


    /** Construct a bitset given the size
     * @param nbits The size of the bitset in bits
     */

    public static BitSet opCall(uint nbits) {
        BitSet result;
        result.length=nbits;
        return result;
    }

    size_t length() const {
        return bitlen;
    }

    void length(size_t newlen)
        {
            if (words.length*bits_per_word < newlen) {
                auto _len=newlen / bits_per_word;
                if ( newlen % bits_per_word ) _len++;
                words.length=_len;
            }
            bitlen=newlen;
        }

    bool opIndex(size_t pos) const {
        if (pos > bitlen) return false;
        return (words[pos / bits_per_word] & bitshift(pos)) != 0;

    }

    unittest // Unittest for opIndex
        {
            BitSet a;
            BitSet b;
            a[0]=a[4]=a[7]=true;
            assert(a[18]==false);
            b[31]=true;
            assert(b[31]==true);
            assert(b[32]==false);
            b[32]=true;
            assert(b[32]==true);
            b[63]=true;
            assert(b[63]==true);

            assert(b[68]==false);
            b[68]=true;
            assert(b[68]==true);

        }

    bool opIndexAssign(bool b, size_t pos)
        {

            if (pos >= bitlen) {
                length=pos+1;
            }
            ulong* word=&words[pos / bits_per_word];
            const ulong mask=bitshift(pos);
            *word&=~mask;
            *word|=(b)?mask:0;
            return b;
        }

    unittest // Unittest for opIndexAssign
        {
            BitSet a;
            a[17]=true;
            assert(a[7]==false);
            assert(a[17]=true);
            a[33]=true;
            assert(a[33]==true);
        }

    bool opEquals(const BitSet rhs) const
        {
            return words==rhs.words && length == rhs.length;
        }

    unittest
        {
            BitSet a, b;
            b[15]=true; b[3]=true;
            a[3]=true; a[15]=true;
            assert(b == a);
            b[7]=true;
            assert(b != a);

        }
    /*
      void opAssign(bool[] bools)
      {
      Stdout("opAssign").newline;
      Stdout.format("bools={}",bools).newline;
      this.bits.opAssign(bools);
      }
    */
    BitSet opAssign(const(ulong)[] rhs) {
        words=rhs.dup;
        bitlen=rhs.length * bits_per_word;
        return this;
    }

    // BitSet opAssign(const(ulong)[] rhs) const {
    //     BitSet result;
    //     result.bits.init(cast(void[])rhs.dup, rhs.sizeof*8);
    //     this.bits=result.bits;
    //     return this;
    // }
    /*
      int opEquals(BitSet rhs) {
      auto a1=this;
      auto a2=&rhs;
      if (a1.length > a2.length) {
      auto tmp=a1; a1=a2; a2=tmp;
      }
      size_t n=a1.length / (uint.sizeof*8);
      uint* p1 = a1.bits.ptr;
      uint* p2 = b2.bits.ptr;
      size_t i;
      for( i = 0; i < n; ++i )
      {
      if( p1[i] != p2[i] )
      return 0; // not equal
      }
      int rest = cast(int)(this.length & cast(size_t)31u);
      uint mask = ~((~0u)<<rest);
      if ((rest == 0) || (p1[i] & mask) == (p2[i] & mask)) {
      for (i = n; i < (a2.lenghth/(unit.sizeof*8)); i++) {
      if (p2[i]!=0)
      return 0;
      }
      } else {
      return 0;
      }
      return 1;
      }
    */

    unittest // Unittest for opEquals
        {
            BitSet a;
            BitSet b;
            a[1]=a[3]=a[7]=true;
            b[1]=b[3]=b[7]=b[9]=true;
            assert(b!=a);
            b[9]=false;
            b.length=a.length;
            assert(a.length==b.length);
            assert(b==a);
            b[1]=false;
            assert(a!=b);
            a[1]=false;
            assert(a==b);
            b[17]=true;
            assert(a!=b);
            a[17]=true;
            assert(a==b);
        }

    BitSet opAnd(const BitSet rhs) const
        {
            BitSet result;
            //result.words.length=max(words.length, rhs.words.length);
            result.length=max(length, rhs.length);
            foreach(i ; 0..min(words.length,rhs.words.length) ) {
                result.words[i] = words[i] & rhs.words[i];
            }
            return result;
        }

    unittest // Unittest for opAnd
        {
            BitSet a     =[0b0110_1010];
            BitSet b     =[0b1000_1110];
            BitSet result=[0b0000_1010];
            auto c=a & b;
            assert(c==result);
            c=b & a;
            assert(c==result);
            a     =[0b1010_1010,0b1111_0000,0b0110_1010];
            b     =[0b1000_0011,0b1010_1111,0b1100_1111];
            result=[0b1000_0010,0b1010_0000,0b0100_1010];
            c=a & b;
            c.length=result.length;
            assert(c==result);
            c=b & a;
            assert(c==result);
        }

    BitSet opOr(const BitSet rhs)
        {
            BitSet result;
            result.words.length=max(words.length, rhs.words.length);
            result.length=max(length, rhs.length);
            int i=0;
            for( ; i< min(words.length, rhs.words.length) ; i++) {
                result.words[i] = words[i] | rhs.words[i];
            }
            for( ; i < words.length ; i++) {
                result.words[i] = words[i];
            }
            for( ; i < rhs.words.length ; i++) {
                result.words[i] = rhs.words[i];
            }
            return result;
        }

    unittest // Unittest for opOr
        {
            BitSet a     =[0b0110_1010];
            BitSet b     =[0b1000_1110];
            BitSet result=[0b1110_1110];
            auto c=a | b;
            assert(c==result);
            c=b | a;
            assert(c==result);
            a     =[0b1010_1010,0b1111_0000,0b0110_1010];
            b     =[0b1000_0011,0b1010_1111,0b1100_1111];
            result=[0b1010_1011,0b1111_1111,0b1110_1111];
            c=a | b;
            assert(c==result);
            c=b | a;
            assert(c==result);
        }

    BitSet opXor(const BitSet rhs)
        {
            BitSet result;
            result.length=max(length, rhs.length);
            int i=0;
            for( ; i < min(words.length,rhs.words.length); i++ ) {
                result.words[i] = words[i] ^ rhs.words[i];
            }
            for( ; i < words.length ; i++) {
                result.words[i]^= words[i];
            }
            for( ; i < rhs.words.length ; i++) {
                result.words[i]^= rhs.words[i];
            }
            return result;
        }

    unittest // Unittest for opXor
        {
            BitSet a     =[0b0110_1010];
            BitSet b     =[0b1000_1110];
            BitSet result=[0b1110_0100];
            auto c=a ^ b;
            assert(c==result);
            c=b ^ a;
            assert(c==result);
            a     =[0b1010_1010,0b1111_0000,0b0110_1010];
            b     =[0b1000_0011,0b1010_1111,0b1100_1111];
            result=[0b0010_1001,0b0101_1111,0b1010_0101];
            c=a ^ b;
            assert(c==result);
            c=b ^ a;
            assert(c==result);
        }


    BitSet opAndAssign( const BitSet rhs )
        {
            return this = this & rhs;
        }

    unittest // Unittest for opAndAssign
        {
            BitSet a     =[0b0110_1010];
            BitSet b     =[0b1000_1110];
            BitSet result=[0b0000_1010];
            auto c=a.dup;
            c&=b;
            assert(c==result);
            c=b.dup;
            c&=a;
            assert(c==result);
            a     =[0b1010_1010,0b1111_0000,0b0110_1010];
            b     =[0b1000_0011,0b1010_1111,0b1100_1111];
            result=[0b1000_0010,0b1010_0000,0b0100_1010];
            c=a.dup;
            c&=b;
            assert(c==result);
            c=b.dup;
            c&=a;
            assert(c==result);

        }


    BitSet opOrAssign( const BitSet rhs )
        {
            this = this | rhs;
            return this;
        }

    unittest // Unittest for opOrAssign
        {
            BitSet a     =[0b0110_1010];
            BitSet b     =[0b1000_1110];
            BitSet result=[0b1110_1110];
            auto c=a.dup;
            c|=b;
            assert(c==result);
            c=b.dup;
            c|=a;
            assert(c==result);
            a     =[0b1010_1010,0b1111_0000,0b0110_1010];
            b     =[0b1000_0011,0b1010_1111,0b1100_1111];
            result=[0b1010_1011,0b1111_1111,0b1110_1111];
            c=a.dup;
            c|=b;
            assert(c==result);
            c=b.dup;
            c|=a;
            assert(c==result);
        }

    BitSet opXorAssign( const BitSet rhs )
        {
            this = this ^ rhs;
            return this;
        }


    unittest // Unittest for opXorAssign
        {
            BitSet a     =[0b0110_1010];
            BitSet b     =[0b1000_1110];
            BitSet result=[0b1110_0100];
            auto c=a.dup;
            c^=b;
            assert(c==result);
            c=b.dup;
            c^=a;
            assert(c==result);
            a     =[0b1010_1010,0b1111_0000,0b0110_1010];
            b     =[0b1000_0011,0b1010_1111,0b1100_1111];
            result=[0b0010_1001,0b0101_1111,0b1010_0101];
            c=a.dup;
            c^=b;
            assert(c==result);
            c=b.dup;
            c^=a;
            assert(c==result);
        }

    BitSet dup() const {
        BitSet result;
        result.words=words.dup;
        result.length=length;
        return result;
    }


    // public int size() {
    //     int deg = 0;
    //     for (int i = cast(int)bits.length - 1; i >= 0; i--) {
    //         ulong word = bits[i];
    //         if (word != 0L) {
    //             for (int bit = BITS - 1; bit >= 0; bit--) {
    //                 if ((word & (1L << bit)) != 0) {
    //                     deg++;
    //                 }
    //             }
    //         }
    //     }
    //     return deg;
    // }

    /*
      public bool isNil() {
      BitSet a=new BitSet();
      return opEquals(a);
      }
    */
    /*
      unittest // Unittest for isNil
      {
      BitSet a=[4, 6];
      assert(!a.isNil);
      a[4]=false;
      a[6]=false;
      assert(a.isNil);
      }
    */

    public immutable(char)[] toString() {
        return toString(null).idup;
    }

    public const(char)[] toString(const(char)[][] tokenNames) {
        auto buf = new Text!(char);
        immutable(char)[] separator = ",";
        bool havePrintedAnElement = false;
        buf~="{";
        for (int i = 0; i < (length); i++) {
            if (opIndex(i)) {
                if (i > 0 && havePrintedAnElement ) {
                    buf.append(separator);
                }
                if ( tokenNames!=null ) {
                    buf.append(tokenNames[i]);
                }
                else {
                    buf.format("{}",i);
                }
                havePrintedAnElement = true;
            }
        }
        buf.append("}");
        return buf.selection;
    }

    unittest // toString unittest
        {
            BitSet a;
            a[1]=a[7]=a[17]=a[28]=a[33]=a[107]=a[218]=true;
            assert(a.toString=="{1,7,17,28,33,107,218}");
            const(char)[][] table=["red","blue","yellow","green","black","white"];
            BitSet b;
            b[1]=b[2]=b[4]=true;
            assert(b.toString(table)=="{blue,yellow,black}");
        }

    unittest {
        // Const assign
        const BitSet bitset=[0b0110_1010];
        class Test {
            const BitSet bits;
            this(const ulong[] words) {
                bits=const BitSet(words);
            }
        }
        Test test=new Test([0b0110_1010]);
    }

}
