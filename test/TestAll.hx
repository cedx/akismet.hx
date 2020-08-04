import akismet.*;
import instrument.coverage.Coverage;
import utest.UTest;

/** Runs the test suite. **/
class TestAll {

	/** The test cases. **/
	static final tests = [
		new AuthorTest(),
		new BlogTest(),
		new ClientTest(),
		new CommentTest()
	];

	/** Application entry point. **/
	static function main() UTest.run(tests, Coverage.endCoverage);
}
