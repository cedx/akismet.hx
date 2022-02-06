import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;
using tink.CoreApi;

/** Submits spam to the Akismet service. **/
function main() {
	final client = new Client("123YourAPIKey", new Blog({url: "https://www.yourblog.com"}));
	final comment = new Comment({
		content: "A user comment",
		author: new Author({
			ipAddress: "192.168.123.456",
			userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36"
		})
	});

	client.submitSpam(comment).handle(outcome -> switch outcome {
		case Success(_): trace("The comment was successfully submitted as spam.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
