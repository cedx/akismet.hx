import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;

using tink.CoreApi;

/** Verifies an Akismet API key. **/
function verifyKey() {
	final blog = new Blog({url: "https://www.yourblog.com"});
	new Client("123YourAPIKey", blog).verifyKey().handle(outcome -> switch outcome {
		case Success(isValid): trace(isValid ? "The API key is valid." : "The API key is invalid.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}

/** Checks a comment against the Akismet service. **/
function checkComment() {
	final author = new Author({
		email: "john.doe@domain.com",
		ipAddress: "192.168.123.456",
		name: "John Doe",
		role: "guest",
		userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36 Edg/94.0.992.38"
	});

	final comment = new Comment({
		author: author,
		date: Date.now(),
		content: "A user comment",
		referrer: "https://cedx.github.io/akismet.hx",
		type: ContactForm
	});

	final blog = new Blog({charset: "UTF-8", languages: ["fr"], url: "https://www.yourblog.com"});
	new Client("123YourAPIKey", blog).checkComment(comment).handle(outcome -> switch outcome {
		case Success(result): trace(result == Ham ? "The comment is ham." : "The comment is spam.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}

/** Submits spam or ham to the Akismet service. **/
function submitSpamOrHam() {
	final client = new Client("123YourAPIKey", new Blog({url: "https://www.yourblog.com"}));
	final comment = new Comment({
		content: "A user comment",
		author: new Author({
			ipAddress: "192.168.123.456",
			userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36 Edg/94.0.992.38"
		})
	});

	client.submitSpam(comment).handle(outcome -> switch outcome {
		case Success(_): trace("The comment was successfully submitted as spam.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});

	client.submitHam(comment).handle(outcome -> switch outcome {
		case Success(_): trace("The comment was successfully submitted as ham.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
