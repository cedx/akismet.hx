package akismet;

/** Specifies the result of a comment check. **/
enum abstract CheckResult(Int) from Int to Int {

	/** The comment is not a spam (i.e. a ham). **/
	var IsHam;

	/** The comment is a spam. **/
	var IsSpam;

	/** The comment is a pervasive spam (i.e. it can be safely discarded). **/
	var IsPervasiveSpam;
}
