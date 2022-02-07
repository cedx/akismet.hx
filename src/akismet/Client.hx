package akismet;

import akismet.RemoteApi.CommentCheckApi;
import akismet.RemoteApi.KeyVerificationApi;
import tink.Anon;
import tink.Url;
import tink.Web;
import tink.http.Fetch.FetchResponse;
import tink.http.Header.HeaderField;
import tink.http.Request.OutgoingRequest;
import tink.http.Response.IncomingResponse;
import tink.web.proxy.Remote;
using StringTools;
using haxe.io.Path;

/** Submits comments to the [Akismet](https://akismet.com) service. **/
class Client {

	/** The response returned by the `submit-ham` and `submit-spam` endpoints when the outcome is a success. **/
	static inline final successResponse = "Thanks for making the web a better place.";

	/** The Akismet API key. **/
	public final apiKey: String;

	/** The base URL of the remote API endpoint. **/
	public final baseUrl: Url = "https://rest.akismet.com/1.1/";

	/** The front page or home URL of the instance making requests. **/
	public final blog: Blog;

	/** Value indicating whether the client operates in test mode. **/
	public final isTest = false;

	/** The user agent string to use when making requests. **/
	public final userAgent = 'Haxe/${Version.haxeVersion} | Akismet/${Version.packageVersion}';

	/** The remote API client for comment check. **/
	final remoteCommentCheck: Remote<CommentCheckApi>;

	/** The remote API client for key verification. **/
	final remoteKeyVerification: Remote<KeyVerificationApi>;

	/** Creates a new client. **/
	public function new(apiKey: String, blog: Blog, ?options: ClientOptions) {
		this.apiKey = apiKey;
		this.blog = blog;

		if (options != null) {
			if (options.baseUrl != null) baseUrl = Path.addTrailingSlash(options.baseUrl);
			if (options.isTest != null) isTest = options.isTest;
			if (options.userAgent != null) userAgent = options.userAgent;
		}

		final endPoint = Url.parse('${baseUrl.scheme}://$apiKey.${baseUrl.host}${baseUrl.path}');
		final pipeline = {before: [onRequest], after: [onResponse]};
		remoteCommentCheck = Web.connect((endPoint: CommentCheckApi), {augment: pipeline});
		remoteKeyVerification = Web.connect((baseUrl: KeyVerificationApi), {augment: pipeline});
	}

	/** Checks the specified `comment` against the service database, and returns a value indicating whether it is spam. **/
	public function checkComment(comment: Comment) {
		final body = Anon.merge(blog.toFormData(), comment.toFormData(), is_test = isTest ? "1" : "0");
		return (remoteCommentCheck.checkComment(body): FetchResponse).all().next(message ->
			if (message.body.toString() == "false") CheckResult.Ham
			else {
				final akismetHeaders = message.header.get("x-akismet-pro-tip");
				akismetHeaders.length > 0 && akismetHeaders[0] == "discard" ? CheckResult.PervasiveSpam : CheckResult.Spam;
			}
		);
	}

	/** Submits the specified `comment` that was incorrectly marked as spam but should not have been. **/
	public function submitHam(comment: Comment) {
		final body = Anon.merge(blog.toFormData(), comment.toFormData(), is_test = isTest ? "1" : "0");
		return remoteCommentCheck.submitHam(body).next(IncomingResponse.readAll).next(chunk -> chunk.toString() == successResponse);
	}

	/** Submits the specified `comment` that was not marked as spam but should have been. **/
	public function submitSpam(comment: Comment) {
		final body = Anon.merge(blog.toFormData(), comment.toFormData(), is_test = isTest ? "1" : "0");
		return remoteCommentCheck.submitSpam(body).next(IncomingResponse.readAll).next(chunk -> chunk.toString() == successResponse);
	}

	/** Checks the API key against the service database, and returns a value indicating whether it is valid. **/
	public function verifyKey() {
		final body = Anon.merge(blog.toFormData(), key = apiKey);
		return remoteKeyVerification.verifyKey(body).next(IncomingResponse.readAll).next(chunk -> chunk.toString() == "valid");
	}

	/** Intercepts and modifies the outgoing requests. **/
	function onRequest(request: OutgoingRequest)
		return Promise.resolve(new OutgoingRequest(request.header.concat([new HeaderField(USER_AGENT, userAgent)]), request.body));

	/** Intercepts and modifies the incoming responses. **/
	function onResponse(request: OutgoingRequest) return function(response: IncomingResponse) {
		final akismetHeaders = response.header.get("x-akismet-debug-help");
		return akismetHeaders.length > 0 ? Promise.reject(new Error(BadRequest, akismetHeaders[0])) : Promise.resolve(response);
	};
}

/** Defines the options of a `Client` instance. **/
typedef ClientOptions = {

	/** The base URL of the remote API endpoint. **/
	var ?baseUrl: Url;

	/** Value indicating whether the client operates in test mode. **/
	var ?isTest: Bool;

	/** The user agent string to use when making requests. **/
	var ?userAgent: String;
}
