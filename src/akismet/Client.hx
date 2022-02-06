package akismet;

import akismet.RemoteApi.CommentCheckApi;
import akismet.RemoteApi.KeyVerificationApi;
import haxe.io.Bytes;
import tink.Url;
import tink.Web;
import tink.http.Client as HttpClient;
import tink.http.Fetch.FetchOptions;
import tink.http.Header.HeaderField;
import tink.http.Request.OutgoingRequest;
import tink.http.Response.IncomingResponse;
import tink.url.Query;
import tink.web.proxy.ConnectOptions;
import tink.web.proxy.Remote;
using StringTools;
using haxe.io.Path;

/** Submits comments to the [Akismet](https://akismet.com) service. **/
class Client {

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

	/** The resolved API endpoint. **/
	final endPoint: Url;

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

		endPoint = '${baseUrl.scheme}://$apiKey.${baseUrl.host}${baseUrl.path}';

		final handlers = {before: [onRequest], after: [onResponse]};
		remoteCommentCheck = Web.connect(('${baseUrl.scheme}://$apiKey.${baseUrl.host}${baseUrl.path}': CommentCheckApi), {augment: handlers});
		remoteKeyVerification = Web.connect((baseUrl: KeyVerificationApi), {augment: handlers});
	}

	/** Checks the specified `comment` against the service database, and returns a value indicating whether it is spam. **/
	public function checkComment(comment: Comment)
		return fetch(endPoint.resolve("comment-check"), comment.toMap()).next(response ->
			if (response.body.toString() == "false") CheckResult.Ham
			else {
				final akismetHeader = response.header.get("x-akismet-pro-tip");
				akismetHeader.length > 0 && akismetHeader[0] == "discard" ? CheckResult.PervasiveSpam : CheckResult.Spam;
			}
		);

	/** Submits the specified `comment` that was incorrectly marked as spam but should not have been. **/
	public function submitHam(comment: Comment)
		return fetch(endPoint.resolve("submit-ham"), comment.toMap()).noise();

	/** Submits the specified `comment` that was not marked as spam but should have been. **/
	public function submitSpam(comment: Comment)
		return fetch(endPoint.resolve("submit-spam"), comment.toMap()).noise();

	/** Checks the API key against the service database, and returns a value indicating whether it is valid. **/
	public function verifyKey() return remoteKeyVerification.verifyKey({key: apiKey, blog: blog.url})
		.next(IncomingResponse.readAll)
		.next(chunk -> chunk.toString() == "valid");

	/** Queries the service by posting the specified fields and returns the response. **/
	function fetch(url: Url, fields: Map<String, String>) {
		final body = Query.build();
		for (key => value in blog.toMap()) body.add(key, value);
		for (key => value in fields) body.add(key, value);
		if (isTest) body.add("is_test", "true");

		final bytes = Bytes.ofString(body.toString());
		final headers = [
			new HeaderField(CONTENT_LENGTH, bytes.length),
			new HeaderField(CONTENT_TYPE, "application/x-www-form-urlencoded"),
			new HeaderField(USER_AGENT, userAgent)
		];

		final options: FetchOptions = {method: POST, headers: headers, body: bytes};
		return HttpClient.fetch(url, options).all().next(response -> {
			final akismetHeader = response.header.get("x-akismet-debug-help");
			akismetHeader.length > 0 ? new Error(UnprocessableEntity, akismetHeader[0]) : response;
		});
	}

	/** Intercepts and modifies the outgoing requests. **/
	function onRequest(request: OutgoingRequest)
		return Promise.resolve(new OutgoingRequest(request.header.concat([new HeaderField(USER_AGENT, userAgent)]), request.body));

	/** Intercepts and modifies the incoming responses. **/
	function onResponse(request: OutgoingRequest) return function(response: IncomingResponse) {
		final akismetHeaders = response.header.get("x-akismet-debug-help");
		return akismetHeaders.length > 0 ? Promise.reject(new Error(UnprocessableEntity, akismetHeaders[0])) : Promise.resolve(response);
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
