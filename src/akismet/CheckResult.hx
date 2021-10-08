package akismet;

/** Specifies the result of a comment check. **/
enum CheckResult {

	/** The comment is not a spam (i.e. a ham). **/
	Ham;

	/** The comment is a spam. **/
	Spam;

	/** The comment is a pervasive spam (i.e. it can be safely discarded). **/
	PervasiveSpam;
}
