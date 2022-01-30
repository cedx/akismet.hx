import akismet.Blog;
import akismet.Client;
using tink.CoreApi;

/** Verifies an Akismet API key. **/
function main() {
	final blog = new Blog({url: "https://www.yourblog.com"});
	new Client("123YourAPIKey", blog).verifyKey().handle(outcome -> switch outcome {
		case Success(isValid): trace(isValid ? "The API key is valid." : "The API key is invalid.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
