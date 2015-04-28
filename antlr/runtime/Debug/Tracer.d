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
module antlr.runtime.Debug.Tracer;

import antlr.runtime.IntStream;
import antlr.runtime.TokenStream;
import antlr.runtime.Debug.BlankDebugEventListener;
import antlr.runtime.tango.Format;

import tango.io.Stdout;

/** The default tracer mimics the traceParser behavior of ANTLR 2.x.
 *  This listens for debugging events from the parser and implies
 *  that you cannot debug and trace at the same time.
 */
public abstract class Tracer(char_t) : BlankDebugEventListener!(char_t) {
	public IntStream input;
	protected int level = 0;

	public this(IntStream input) {
		this.input = input;
	}

	public void enterRule(char_t[] ruleName) {
		for (int i=1; i<=level; i++) {Stdout(" ");}
		Stdout("> ")(ruleName)(" lookahead(1)=")(getInputSymbol(1)).newline;
		level++;
	}

	public void exitRule(char_t[] ruleName) {
		level--;
		for (int i=1; i<=level; i++) {Stdout(" ");}
		Stdout("< ")(ruleName)(" lookahead(1)=")(getInputSymbol(1)).newline;
	}

	public char_t[] getInputSymbol(int k) {
	  if ( is(typeof(input) == TokenStream) ) {
		return (cast(TokenStream)input).LT(k).Text;
	  }
	  return Format16("{}",input.LA(k));
	}
}


