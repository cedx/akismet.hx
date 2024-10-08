import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;
using tink.CoreApi;

/** Submits ham to the Akismet service. **/
function main() {
	final blog = new Blog({url: "https://www.yourblog.com"});
	final client = new Client("123YourAPIKey", blog);

	final comment = new Comment({
		content: "I'm testing out the Service API.",
		author: new Author({
			ipAddress: "192.168.123.456",
			userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0"
		})
	});

	client.submitHam(comment).handle(outcome -> switch outcome {
		case Success(_): trace("The comment was successfully submitted as ham.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
