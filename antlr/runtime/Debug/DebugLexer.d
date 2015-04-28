// $ANTLR 3.1b1 Debug.g 2010-10-04 16:49:20

module antlr.runtime.Debug.DebugLexer;


import antlr.runtime.Lexer;
import antlr.runtime.Parser;
import antlr.runtime.CharStream;
import antlr.runtime.IntStream;
import antlr.runtime.TokenStream;
import antlr.runtime.TokenRewriteStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;
import antlr.runtime.BaseRecognizer;
import antlr.runtime.RecognizerSharedState;
import antlr.runtime.NoViableAltException;
import antlr.runtime.MismatchedSetException;
import antlr.runtime.EarlyExitException;
import antlr.runtime.RecognitionException;
import antlr.runtime.FailedPredicateException;
import antlr.runtime.ParserRuleReturnScope;
import antlr.runtime.DFA;
import antlr.runtime.BitSet;

// Tango 
import tango.io.Stdout;
//import tango.util.collection.ArraySeq;
import tango.util.container.more.Stack;
 //fixme[3]
 /*
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;
 */

class DebugLexer(Token_t=CommonToken) : Lexer!(Token_t) {
    const int WS=6;
    const int DIGIT=5;
    const int ID=4;
    const int EOF=-1;

    // delegates
    // delegators
    static public this() {
//--- static public
//    	   
    } 
/* ---
    public DebugLexer(CharStream input) {
        this(input, new RecognizerSharedState());
    }
*/
    public this(CharStream input) {
        this(input, new RecognizerSharedState());
       // Lexer init settings
    }
/* ---
    public DebugLexer(CharStream input, RecognizerSharedState state) {
        super(input,state);
*/
    public this(CharStream input, RecognizerSharedState state) {
        super(input,state);
	


    }
    public char[] getGrammarFileName() { return "Debug.g"; }

    // fixme[55]
    // $ANTLR start DIGIT
    public void mDIGIT() {
        try {
            int _type = DIGIT;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // Debug.g:16:6: ( ( '0' .. '9' )+ )
            // Debug.g:16:8: ( '0' .. '9' )+
            {
            // Debug.g:16:8: ( '0' .. '9' )+
            int cnt1=0;
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( ((LA1_0>='0' && LA1_0<='9')) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // Debug.g:16:9: '0' .. '9'
            	    {
            	    matchRange('0','9'); 

            	    }
            	    break;

            	default :
            	    if ( cnt1 >= 1 ) break loop1;
                        EarlyExitException eee =
                            new EarlyExitException(1, input);
                        throw eee;
                }
                cnt1++;
            } while (true);


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end DIGIT

    // fixme[55]
    // $ANTLR start ID
    public void mID() {
        try {
            int _type = ID;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // Debug.g:18:3: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' ) ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' )* )
            // Debug.g:18:5: ( 'a' .. 'z' | 'A' .. 'Z' | '_' ) ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' )*
            {
            if ( (input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
                input.consume();

            }
            else {
                BitSet empty;
                MismatchedSetException mse = new MismatchedSetException(empty,input);
                recover(mse);
                throw mse;}

            // Debug.g:18:29: ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( ((LA2_0>='0' && LA2_0<='9')||(LA2_0>='A' && LA2_0<='Z')||LA2_0=='_'||(LA2_0>='a' && LA2_0<='z')) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // Debug.g:
            	    {
            	    if ( (input.LA(1)>='0' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();

            	    }
            	    else {
            	        BitSet empty;
            	        MismatchedSetException mse = new MismatchedSetException(empty,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end ID

    // fixme[55]
    // $ANTLR start WS
    public void mWS() {
        try {
            int _type = WS;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // Debug.g:20:3: ( ( ' ' | '\\n' )+ )
            // Debug.g:20:5: ( ' ' | '\\n' )+
            {
            // Debug.g:20:5: ( ' ' | '\\n' )+
            int cnt3=0;
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0=='\n'||LA3_0==' ') ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // Debug.g:
            	    {
            	    if ( input.LA(1)=='\n'||input.LA(1)==' ' ) {
            	        input.consume();

            	    }
            	    else {
            	        BitSet empty;
            	        MismatchedSetException mse = new MismatchedSetException(empty,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt3 >= 1 ) break loop3;
                        EarlyExitException eee =
                            new EarlyExitException(3, input);
                        throw eee;
                }
                cnt3++;
            } while (true);

            _channel = HIDDEN;

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end WS

    public void mTokens() {
        // Debug.g:1:8: ( DIGIT | ID | WS )
        int alt4=3;
        switch ( input.LA(1) ) {
        // Fixme[105]
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            {
            alt4=1;
            }
            break;
        case 'A':
        case 'B':
        case 'C':
        case 'D':
        case 'E':
        case 'F':
        case 'G':
        case 'H':
        case 'I':
        case 'J':
        case 'K':
        case 'L':
        case 'M':
        case 'N':
        case 'O':
        case 'P':
        case 'Q':
        case 'R':
        case 'S':
        case 'T':
        case 'U':
        case 'V':
        case 'W':
        case 'X':
        case 'Y':
        case 'Z':
        case '_':
        case 'a':
        case 'b':
        case 'c':
        case 'd':
        case 'e':
        case 'f':
        case 'g':
        case 'h':
        case 'i':
        case 'j':
        case 'k':
        case 'l':
        case 'm':
        case 'n':
        case 'o':
        case 'p':
        case 'q':
        case 'r':
        case 's':
        case 't':
        case 'u':
        case 'v':
        case 'w':
        case 'x':
        case 'y':
        case 'z':
            {
            alt4=2;
            }
            break;
        case '\n':
        case ' ':
            {
            alt4=3;
            }
            break;
        default:
            NoViableAltException nvae =
                new NoViableAltException("", 4, 0, input);

            throw nvae;
        }

        switch (alt4) {
            case 1 :
                // Debug.g:1:10: DIGIT
                {
                mDIGIT(); 

                }
                break;
            case 2 :
                // Debug.g:1:16: ID
                {
                mID(); 

                }
                break;
            case 3 :
                // Debug.g:1:19: WS
                {
                mWS(); 

                }
                break;

            default:
            // Empty
        }

    }


 

}