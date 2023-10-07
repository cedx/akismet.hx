package akismet;

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
final class Client {

	/** The response returned by the `submit-ham` and `submit-spam` endpoints when the outcome is a success. **/
	static final success = "Thanks for making the web a better place.";

	/** The Akismet API key. **/
	public final apiKey: String;

	/** The base URL of the remote API endpoint. **/
	public final baseUrl: Url;

	/** The front page or home URL of the instance making requests. **/
	public final blog: Blog;

	/** Value indicating whether the client operates in test mode. **/
	public final isTest: Bool;

	/** The remote API client. **/
	final remote: Remote<RemoteApi>;

	/** Creates a new client. **/
	public function new(apiKey: String, blog: Blog, ?options: ClientOptions) {
		this.apiKey = apiKey;
		this.blog = blog;
		baseUrl = (options?.baseUrl?.toString() ?? "https://rest.akismet.com").addTrailingSlash();
		isTest = options?.isTest ?? false;
		remote = Web.connect((baseUrl: RemoteApi), {
			augment: {after: [onResponse]},
			headers: [new HeaderField(USER_AGENT, options?.userAgent ?? 'Haxe/${Platform.haxeVersion} | Akismet/${Platform.packageVersion}')]
		});
	}

	/** Checks the specified `comment` against the service database, and returns a value indicating whether it is spam. **/
	public function checkComment(comment: Comment)
		return (remote.checkComment(Anon.merge(blog.formData, comment.formData, {api_key: apiKey, is_test: isTest ? "1" : null})): FetchResponse).all()
			.next(response -> response.body.toString() == "false" ? CheckResult.Ham : switch response.header.byName("X-akismet-pro-tip") {
				case Success(proTip) if (proTip == "discard"): CheckResult.PervasiveSpam;
				default: CheckResult.Spam;
			});

	/** Submits the specified `comment` that was incorrectly marked as spam but should not have been. **/
	public function submitHam(comment: Comment)
		return remote.submitHam(Anon.merge(blog.formData, comment.formData, {api_key: apiKey, is_test: isTest ? "1" : null}))
			.next(IncomingResponse.readAll)
			.next(chunk -> chunk.toString() == success ? Success(Noise) : Failure(new Error("Invalid server response.")));

	/** Submits the specified `comment` that was not marked as spam but should have been. **/
	public function submitSpam(comment: Comment)
		return remote.submitSpam(Anon.merge(blog.formData, comment.formData, {api_key: apiKey, is_test: isTest ? "1" : null}))
			.next(IncomingResponse.readAll)
			.next(chunk -> chunk.toString() == success ? Success(Noise) : Failure(new Error("Invalid server response.")));

	/** Checks the API key against the service database, and returns a value indicating whether it is valid. **/
	public function verifyKey()
		return remote.verifyKey(Anon.merge(blog.formData, key = apiKey))
			.next(IncomingResponse.readAll)
			.next(chunk -> chunk.toString() == "valid");

	/** Intercepts and modifies the incoming responses. **/
	function onResponse(request: OutgoingRequest) return function(response: IncomingResponse): Promise<IncomingResponse>
		return switch response.header.byName("X-akismet-alert-code") {
			case Success(alertCode): Failure(new Error(Std.parseInt(alertCode), response.header.byName("X-akismet-alert-msg").sure()));
			case Failure(_): switch response.header.byName("X-akismet-debug-help") {
				case Success(debugHelp): Failure(new Error(BadRequest, debugHelp));
				case Failure(_): Success(response);
			}
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
