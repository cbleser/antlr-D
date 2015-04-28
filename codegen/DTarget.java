/*
 [The "BSD licence"]
 Copyright (c) 2005-2006 Terence Parr
 Copyrigth (c) 2008-2009 Carsten Bleser Rasmussen 
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

/* Antlr codegen interface for D */
/* SWMSEMI (Silicide/Polaric) (SWM) */
/* History */
/*   Initial version 25-mar-2009/cbr */

package org.antlr.codegen;

import org.antlr.analysis.Label;
import org.antlr.Tool;
import org.antlr.stringtemplate.StringTemplate;
import org.antlr.tool.Grammar;

public class DTarget extends Target {
    final char UTF16_MAX_VALUE = 0xFFFD; 
    /** Convert from an ANTLR char literal found in a grammar file to
     *  an equivalent char literal in the target language.  For most
     *  languages, this means leaving 'x' as 'x'.  Actually, we need
     *  to escape '\u000A' so that it doesn't get converted to \n by
     *  the compiler.  Convert the literal to the char value and then
     *  to an appropriate target char literal.
     *
     *  Expect single quotes around the incoming literal.
     */
    public String getTargetCharLiteralFromANTLRCharLiteral(
	CodeGenerator generator,
	String literal)
    {
	StringBuffer buf = new StringBuffer();
	buf.append('\'');
	int c = Grammar.getCharValueFromGrammarCharLiteral(literal);
	if ( c<Label.MIN_CHAR_VALUE ) {
	    return "'\u0000'";
	}
	if ( c<targetCharValueEscape.length &&
	    targetCharValueEscape[c]!=null )
	{
	    buf.append(targetCharValueEscape[c]);
	}
	else if ( Character.UnicodeBlock.of((char)c)==
	    Character.UnicodeBlock.BASIC_LATIN &&
	    !Character.isISOControl((char)c) )
	{
	    // normal char
	    buf.append((char)c);
	}
	else {
	    // must be something unprintable...use \\uXXXX
	    // turn on the bit above max "\\uFFFF" value so that we pad with zeros
	    // then only take last 4 digits

	    // Convert char c to legal Unicode char
	    if (c > UTF16_MAX_VALUE) {
		c=UTF16_MAX_VALUE;
	    }

	    String hex = Integer.toHexString(c|0x10000).toUpperCase().substring(1,5);
	    buf.append("\\u");
	    buf.append(hex);
	}
	
	buf.append('\'');
	return buf.toString();
    }


    /**
     * D doesn't support Unicode String literals that are considered "illegal"
     * or are in the surrogate pair ranges.  For example "\uffff" will not encode properly
     * nor will "\ud800".  To keep things as compact as possible we use the following encoding
     * If the int is between 0x0000 and 0x7fff we use a single unicode literal with the value
     * If the int is above 0x7fff, we use two unicode literal the first one contains MSB bit
     * and the second unicode the rest of the bit's
     *
     * Example
     *  v="\ud83a" is converted into result="\u8000\u583a" 
     *  
     * This means that the value can be converted back to the original
     * value by adding/oring the unicodes
     *  v=0x8000 | 0x583a=0x8000 + 0x583a
     *
     * @param v
     * @return
     */
    public String encodeIntAsCharEscape(int v) {
        // encode as hex
        if (v <= 0x7fff) {
            String hex = Integer.toHexString(v|0x10000).substring(1,5);
	    return "\\u"+hex;
        }
        if (v > 0xffff) {
            System.err.println("Warning: character literal out of range for ActionScript target " + v);
            return "\\uffff"; // Returns an illegal unicode to stop D
							 // from compiling
        }
        String hex = Integer.toHexString((v&0x7fff)|0x10000).substring(1,5);
        StringBuffer buf = new StringBuffer("\\u8000\\u");
	buf.append(hex);
	return buf.toString();
    }

    /** 
     *  Maximum wchar value is 0xfffd.
     */
    public int getMaxCharValue(CodeGenerator generator) {
	return 0xfffd;
    }


    protected StringTemplate chooseWhereCyclicDFAsGo(Tool tool,
                                                     CodeGenerator generator,
                                                     Grammar grammar,
                                                     StringTemplate recognizerST,
                                                     StringTemplate cyclicDFAST) {
        return recognizerST;
    }
}

