package akismet;

import haxe.io.Bytes;
import tink.Url;
import tink.http.Client as HttpClient;
import tink.http.Fetch.FetchOptions;
import tink.http.Header.HeaderField;
import tink.url.Query;

using StringTools;
using haxe.io.Path;
using tink.CoreApi;

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

	/** Creates a new client. **/
	public function new(apiKey: String, blog: Blog, ?options: ClientOptions) {
		if (options != null) {
			if (options.baseUrl != null) baseUrl = Path.addTrailingSlash(options.baseUrl);
			if (options.isTest != null) isTest = options.isTest;
			if (options.userAgent != null) userAgent = options.userAgent;
		}

		this.apiKey = apiKey;
		this.blog = blog;
		endPoint = '${baseUrl.scheme}://$apiKey.${baseUrl.host}${baseUrl.path}';
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
	public function verifyKey()
		return fetch(baseUrl.resolve("verify-key"), ["key" => apiKey]).next(response -> response.body.toString() == "valid");

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
			new HeaderField("user-agent", userAgent)
		];

		final options: FetchOptions = {method: POST, headers: headers, body: bytes};
		return HttpClient.fetch(url, options).all().next(response -> {
			final akismetHeader = response.header.get("x-akismet-debug-help");
			akismetHeader.length > 0 ? new Error(UnprocessableEntity, akismetHeader[0]) : response;
		});
	}
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
