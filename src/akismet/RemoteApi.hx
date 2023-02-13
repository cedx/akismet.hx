package akismet;

import akismet.Blog.BlogFormData;
import akismet.Comment.CommentFormData;

/** Defines the interface of the comment check API. **/
interface CommentCheckApi {

	/** Checks the specified comment against the service database, and returns a value indicating whether it is spam. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/comment-check")
	@:produces("text/plain")
	function checkComment(body: CommentCheckFormData): String;

	/** Submits the specified comment that was incorrectly marked as spam but should not have been. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/submit-ham")
	@:produces("text/plain")
	function submitHam(body: CommentCheckFormData): String;

	/** Submits the specified comment that was not marked as spam but should have been. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/submit-spam")
	@:produces("text/plain")
	function submitSpam(body: CommentCheckFormData): String;
}

/** Defines the form data of a comment check request. **/
typedef CommentCheckFormData = BlogFormData & CommentFormData & {

	/** Value indicating whether the client operates in test mode. **/
	var ?is_test: String;
}

/** Defines the interface of the key verification API. **/
interface KeyVerificationApi {

	/** Checks the specified API key against the service database, and returns a value indicating whether it is valid. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/verify-key")
	@:produces("text/plain")
	function verifyKey(body: KeyVerificationFormData): String;
}

/** Defines the form data of a key verification request. **/
typedef KeyVerificationFormData = BlogFormData & {

	/** The API key to verify. **/
	var key: String;
}
