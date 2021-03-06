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
module antlr.runtime.misc.Stats;

import tango.io.FilePath;
import tango.io.device.File;
import tango.math.Math;
import tango.sys.Environment;
/** Stats routines needed by profiler etc...

 // note that these routines return 0.0 if no values exist in the X[]
 // which is not "correct", but it is useful so I don't generate NaN
 // in my output

 */
public class Stats {
	public const char[] ANTLRWORKS_DIR = "antlrworks";

	/** Compute the sample (unbiased estimator) standard deviation following:
	 *
	 *  Computing Deviations: Standard Accuracy
	 *  Tony F. Chan and John Gregg Lewis
	 *  Stanford University
	 *  Communications of ACM September 1979 of Volume 22 the ACM Number 9
	 *
	 *  The "two-pass" method from the paper; supposed to have better
	 *  numerical properties than the textbook summation/sqrt.  To me
	 *  this looks like the textbook method, but I ain't no numerical
	 *  methods guy.
	 */
	public static double stddev(int[] X) {
		auto m = X.length;
		if ( m<=1 ) {
			return 0;
		}
		double xbar = avg(X);
		double s2 = 0.0;
		for (int i=0; i<m; i++){
			s2 += (X[i] - xbar)*(X[i] - xbar);
		}
		s2 = s2/(m-1);
		return sqrt(s2);
	}

	/** Compute the sample mean */
	public static double avg(int[] X) {
		double xbar = 0.0;
		auto m = X.length;
		if ( m==0 ) {
			return 0;
		}
		for (int i=0; i<m; i++){
			xbar += X[i];
		}
		if ( xbar>=0.0 ) {
			return xbar / m;
		}
		return 0.0;
	}

	public static int min(int[] X) {
	  int min = int.max;
		auto m = X.length;
		if ( m==0 ) {
			return 0;
		}
		for (int i=0; i<m; i++){
			if ( X[i] < min ) {
				min = X[i];
			}
		}
		return min;
	}

	public static int max(int[] X) {
	  int max = int.min;
		auto m = X.length;
		if ( m==0 ) {
			return 0;
		}
		for (int i=0; i<m; i++){
			if ( X[i] > max ) {
				max = X[i];
			}
		}
		return max;
	}

	public static int sum(int[] X) {
		int s = 0;
		auto m = X.length;
		if ( m==0 ) {
			return 0;
		}
		for (int i=0; i<m; i++){
			s += X[i];
		}
		return s;
	}

	public static void writeReport(char[] filename, char[] data) {
	  //  auto filepath=FilePath(filename);
	  //  auto parent=filepath.parent;
// 		auto absoluteFilename = FilePath(filename).path;
// 		auto f = new FileConduit(absoluteFilename);
// 		File parent = f.getP28arentFile();
// 		parent.mkdirs();
// 		filepath.parent.mkdir;
	  //   if (!parent.isFolder()) parent.createFolder;
        // ensure parent dir exists
		// write file
		auto fos=new File(filename, File.WriteCreate);
		fos.output.write(data);
		scope (exit) fos.close;
	}

	public static char[] getAbsoluteFileName(char[] filename) {
	  auto filepath=FilePath(Environment.get("HOME"));
	  filepath.append(ANTLRWORKS_DIR).append(filename);
	  return filepath.path;
	}
}
