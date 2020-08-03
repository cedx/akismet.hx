package akismet;

import haxe.io.Path;
import thenshim.Promise;
import tink.Url;

#if nodejs
import npm.Fetch;
import haxe.Exception;
import haxe.http.HttpMethod;
import js.html.Headers;
import js.html.RequestInit;
import js.html.URLSearchParams;
using js.lib.HaxeIterator;
#else
import haxe.Http;
using StringTools;
#end

/** Submits comments to the [Akismet](https://akismet.com) service. **/
@:expose class Client {

	/** The Akismet API key. **/
	public var apiKey: String;

	/** The front page or home URL of the instance making requests. **/
	public var blog: Blog;

	/** The URL of the API end point. **/
	public var endPoint = "https://rest.akismet.com/1.1";

	/** Value indicating whether the client operates in test mode. **/
	public var isTest = false;

	/** The user agent string to use when making requests. **/
	public var userAgent = 'Haxe/${Version.getCompilerVersion()}-${Target.getName()} | Akismet/${Version.getPackageVersion()}';

	/** Creates a new client. **/
	public function new(apiKey: String, blog: Blog, ?options: #if php NativeStructArray<ClientOptions> #else ClientOptions #end) {
		this.apiKey = apiKey;
		this.blog = blog;

		if (options != null) {
			#if php
				if (isset(options["endPoint"])) endPoint = Path.removeTrailingSlashes(options["endPoint"]);
				if (isset(options["isTest"])) isTest = options["isTest"];
				if (isset(options["userAgent"])) userAgent = options["userAgent"];
			#else
				if (options.endPoint != null) endPoint = Path.removeTrailingSlashes(options.endPoint);
				if (options.isTest != null) isTest = options.isTest;
				if (options.userAgent != null) userAgent = options.userAgent;
			#end
		}
	}

	/** Checks the specified `comment` against the service database, and returns a value indicating whether it is spam. **/
	public function checkComment(comment: Comment): Promise<CheckResult> {
		final url: Url = endPoint;
		return fetch('${url.scheme}://$apiKey.${url.host}${url.path}/comment-check', comment.toJson()).then(response ->
			if (response.body == "false") CheckResult.IsHam
			else response.headers["X-akismet-pro-tip"] == "discard" ? CheckResult.IsPervasiveSpam : CheckResult.IsSpam
		);
	}

	/** Submits the specified `comment` that was incorrectly marked as spam but should not have been. **/
	public function submitHam(comment: Comment): Promise<Dynamic> {
		final url: Url = endPoint;
		return fetch('${url.scheme}://$apiKey.${url.host}${url.path}/submit-ham', comment.toJson());
	}

	/** Submits the specified `comment` that was not marked as spam but should have been. **/
	public function submitSpam(comment: Comment): Promise<Dynamic> {
		final url: Url = endPoint;
		return fetch('${url.scheme}://$apiKey.${url.host}${url.path}/submit-spam', comment.toJson());
	}

	/** Checks the API key against the service database, and returns a value indicating whether it is valid. **/
	public function verifyKey(): Promise<Bool>
		return fetch('$endPoint/verify-key', {key: apiKey}).then(response -> response.body == "valid");

	/** Queries the service by posting the specified fields to a given end point, and returns the response as a string. **/
	function fetch(endPoint: String, fields: DynamicAccess<String>): Promise<ClientResponse> {
		final body = blog.toJson();
		for (key => value in fields) body[key] = value;
		if (isTest) body["is_test"] = "1";

		#if nodejs
			function headersToMap(headers: Headers): Map<String, String>
				return [for (entry in headers.entries()) entry[0] => entry[1]];

			final params: RequestInit = {
				body: new URLSearchParams(body),
				headers: {"Content-Type": "application/x-www-form-urlencoded", "User-Agent": userAgent},
				method: HttpMethod.Post
			};

			return Fetch.fetch(endPoint, params).then(
				response -> {
					if (!response.ok) throw new Exception(response.statusText);
					if (response.headers.has("X-akismet-debug-help")) throw new Exception(response.headers.get("X-akismet-debug-help"));
					response.text().then(text -> {body: text, headers: headersToMap(response.headers)});
				},
				error -> throw new ClientException(error.toString(), endPoint)
			);
		#else
			final http = new Http(endPoint);
			http.setHeader("Content-Type", "application/x-www-form-urlencoded");
			http.setHeader("User-Agent", userAgent);
			http.setPostData([for (key => value in body) '${key.urlEncode()}=${value.urlEncode()}'].join("&"));

			return new Promise<ClientResponse>((resolve, reject) -> {
				http.onData = data -> http.responseHeaders.exists("X-akismet-debug-help")
					? reject(new ClientException(http.responseHeaders["X-akismet-debug-help"], http.url))
					: resolve({body: data, headers: http.responseHeaders});
				http.onError = error -> reject(new ClientException(error, http.url));
				http.request(true);
			});
		#end
	}
}

/** Defines the options of a `Client` instance. **/
typedef ClientOptions = {

	/** The URL of the API end point. **/
	var ?endPoint: String;

	/** Value indicating whether the client operates in test mode. **/
	var ?isTest: Bool;

	/** The user agent string to use when making requests. **/
	var ?userAgent: String;
}

/** TODO **/
typedef ClientResponse = {

	/** TODO **/
	var body: String;

	/** TODO **/
	var headers: Map<String, String>;
}
