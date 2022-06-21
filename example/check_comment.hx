import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;
using tink.CoreApi;

/** Checks a comment against the Akismet service. **/
function main() {
	final author = new Author({
		email: "john.doe@domain.com",
		ipAddress: "192.168.123.456",
		name: "John Doe",
		role: "guest",
		userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36"
	});

	final comment = new Comment({
		author: author,
		date: Date.now(),
		content: "A user comment",
		referrer: "https://github.com/cedx/akismet.hx",
		type: ContactForm
	});

	final blog = new Blog({charset: "UTF-8", languages: ["fr"], url: "https://www.yourblog.com"});
	new Client("123YourAPIKey", blog).checkComment(comment).handle(outcome -> switch outcome {
		case Success(result): trace(result == Ham ? "The comment is ham." : "The comment is spam.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
