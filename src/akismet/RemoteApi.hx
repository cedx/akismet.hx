package akismet;

import akismet.Blog.BlogData;
import akismet.Comment.CommentData;

/** Defines the interface of the remote API. **/
interface RemoteApi {

	/** Checks the specified comment against the service database, and returns a value indicating whether it is spam. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/comment-check")
	@:produces("text/plain")
	function checkComment(body: CommentBody): String;

	/** Submits the specified comment that was incorrectly marked as spam but should not have been. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/submit-ham")
	@:produces("text/plain")
	function submitHam(body: CommentBody): String;

	/** Submits the specified comment that was not marked as spam but should have been. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/submit-spam")
	@:produces("text/plain")
	function submitSpam(body: CommentBody): String;

	/** Checks the specified API key against the service database, and returns a value indicating whether it is valid. **/
	@:consumes("application/x-www-form-urlencoded")
	@:post("/1.1/verify-key")
	@:produces("text/plain")
	function verifyKey(body: KeyBody): String;
}

/** Defines the body of a comment check/submission request. **/
private typedef CommentBody = BlogData & CommentData & SharedBody;

/** Defines the body of a key verification request. **/
private typedef KeyBody = BlogData & SharedBody;

/** Defines the partial body shared by all endpoints. **/
private typedef SharedBody = {

	/** The API key. **/
	var api_key: String;

	/** Value indicating whether the client operates in test mode. **/
	var ?is_test: String;
}
