package akismet;

import akismet.Blog.BlogFormData;
import akismet.Comment.CommentFormData;

@:noDoc interface RemoteApi {

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

	/** Checks the specified API key against the service database, and returns a value indicating whether it is valid. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/verify-key")
	@:produces("text/plain")
	function verifyKey(body: KeyVerificationFormData): String;
}

/** Defines the form data of a comment check request. **/
private typedef CommentCheckFormData = BlogFormData & CommentFormData & {

	/** The API key. **/
	var api_key: String;

	/** Value indicating whether the client operates in test mode. **/
	var ?is_test: String;
}

/** Defines the form data of a key verification request. **/
private typedef KeyVerificationFormData = BlogFormData & {

	/** The API key. **/
	var key: String;
}
