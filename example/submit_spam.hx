import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;
using tink.CoreApi;

/** Submits spam to the Akismet service. **/
function main() {
	final blog = new Blog({url: "https://www.yourblog.com"});
	final client = new Client("123YourAPIKey", blog);

	final comment = new Comment({
		content: "Spam!",
		author: new Author({
			ipAddress: "192.168.123.456",
			userAgent: "Spam Bot/6.6.6"
		})
	});

	client.submitSpam(comment).handle(outcome -> switch outcome {
		case Success(_): trace("The comment was successfully submitted as spam.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
