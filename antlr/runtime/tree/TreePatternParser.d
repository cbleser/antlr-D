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
module antlr.runtime.tree.TreePatternParser;

import antlr.runtime.Token;
import antlr.

runtime.CommonToken;
import antlr.runtime.tree.Tree;
import antlr.runtime.tree.TreePatternLexer;
import antlr.runtime.tree.TreeWizard;
import antlr.runtime.tree.TreeAdaptor;

import tango.io.Stdout;

public class TreePatternParser(char_t) {
  protected TreePatternLexer tokenizer;
  protected int ttype;
  protected TreeWizard wizard;
  protected TreeAdaptor adaptor;

  public this(TreePatternLexer tokenizer, TreeWizard wizard, TreeAdaptor adaptor) {
	this.tokenizer = tokenizer;
	this.wizard = wizard;
	this.adaptor = adaptor;
	ttype = tokenizer.nextToken(); // kickstart
  }

  public Tree pattern() {
	if ( ttype==TreePatternLexer.BEGIN ) {
	  return parseTree();
	}
	else if ( ttype==TreePatternLexer.ID ) {
	  auto node = parseNode();
	  if ( ttype==TreePatternLexer.EOF ) {
		return node;
	  }
	  return null; // extra junk on end
	}
	return null;
  }

  public Tree parseTree() {
	if ( ttype != TreePatternLexer.BEGIN ) {
	  Stdout("no BEGIN").newline;
	  return null;
	}
	ttype = tokenizer.nextToken();
	auto root = parseNode();
	if ( root is null ) {
	  return null;
	}
	while ( ttype==TreePatternLexer.BEGIN ||
		ttype==TreePatternLexer.ID ||
		ttype==TreePatternLexer.PERCENT ||
		ttype==TreePatternLexer.DOT )
	{
	  if ( ttype==TreePatternLexer.BEGIN ) {
		auto subtree = parseTree();
		adaptor.addChild(root, subtree);
	  }
	  else {
		auto child = parseNode();
		if ( child is null ) {
		  return null;
		}
		adaptor.addChild(root, child);
	  }
	}
	if ( ttype != TreePatternLexer.END ) {
	  Stdout("no END").newline;
	  return null;
	}
	ttype = tokenizer.nextToken();
	return root;
  }

  public TreeT parseNode() {
	// "%label:" prefix
	char_t[] label;
	if ( ttype == TreePatternLexer.PERCENT ) {
	  ttype = tokenizer.nextToken();
	  if ( ttype != TreePatternLexer.ID ) {
		return null;
	  }
	  label = tokenizer.sval.toString16();
	  ttype = tokenizer.nextToken();
	  if ( ttype != TreePatternLexer.COLON ) {
		return null;
	  }
	  ttype = tokenizer.nextToken(); // move to ID following colon
	}

	// Wildcard?
	if ( ttype == TreePatternLexer.DOT ) {
	  ttype = tokenizer.nextToken();
	  Token wildcardPayload = new CommonToken(0, ".");
	  auto node =
		  new TreeWizard.WildcardTreePattern(wildcardPayload);
	  if ( label!=null ) {
		node.label = label;
	  }
	  return node;
	}

	// "ID" or "ID[arg]"
	if ( ttype != TreePatternLexer.ID ) {
	  return null;
	}
	char_t[] tokenName = tokenizer.sval.toString16();
	ttype = tokenizer.nextToken();
	if ( tokenName=="nil"w ) {
	  return cast(TreePattern)adaptor.nil();
	}
	char_t[] text = tokenName;
	// check for arg
	char_t[] arg = null;
	if ( ttype == TreePatternLexer.ARG ) {
	  arg = tokenizer.sval.toString16();
	  text = arg;
	  ttype = tokenizer.nextToken();
	}
		
	// create node
	int treeNodeType = wizard.getTokenType(tokenName);
	if ( treeNodeType==Token.INVALID_TOKEN_TYPE ) {
	  return null;
	}
	auto node = adaptor.create(treeNodeType, text);
	if (is (node == TreePattern)) {
	  if ( (label !is null) ) {
		(cast(TreePattern)node).label = label;
	  }
	  if ( (arg !is null) ) {
		(cast(TreePattern)node).hasTextArg = true;
	  }
	}
	return node;
  }
}
