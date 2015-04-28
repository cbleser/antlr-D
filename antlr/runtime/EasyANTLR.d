module antlr.runtime.EasyANTLR;


private import antlr.runtime.ANTLRStringStream;
private import antlr.runtime.CommonTokenStream;
private import antlr.runtime.TokenSource;

ANTLRStringStream!(char_t) ANTLRStringStreamT(char_t)(char_t[] input) {
  return new ANTLRStringStream!(char_t)(input);
}


CommonTokenStream!(char_t) CommonTokenStreamT(char_t)(
	TokenSource!(char_t) tokenSource,
	int channel=0)
{
  return new CommonTokenStream!(char_t)(tokenSource, channel);
}
