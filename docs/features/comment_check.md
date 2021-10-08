# Comment check
This is the call you will make the most. It takes a number of arguments and characteristics about the submitted content
and then returns a thumbs up or thumbs down. **Performance can drop dramatically if you choose to exclude data points.**
The more data you send Akismet about each comment, the greater the accuracy. We recommend erring on the side of including too much data.

```haxe
Client.checkComment(comment: Comment): Promise<CheckResult>
```

It is important to [test Akismet](testing.md) with a significant amount of real, live data in order to draw any conclusions on accuracy.
Akismet works by comparing content to genuine spam activity happening **right now** (and this is based on more than just the content itself),
so artificially generating spam comments is not a viable approach.

See the [Akismet API documentation](https://akismet.com/development/api/#comment-check) for more information.

## Parameters

### **comment**: Comment
The `Comment` providing the user's message to be checked.

## Return value
A `Promise` that resolves with a `CheckResult` value indicating whether the given `Comment` is ham, spam or pervasive spam.

?> A comment classified as pervasive spam can be safely discarded.

The promise rejects with an `UnprocessableEntity` error when an issue occurs.
The error `message` usually includes some debug information, provided by the `X-akismet-debug-help` HTTP header,
about what exactly was invalid about the call.

## Example

```haxe
import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;

function main() {
	final comment = new Comment({
		author: new Author({ipAddress: "127.0.0.1", userAgent: "Mozilla/5.0"}),
		content: "A user comment",
		date: Date.now()
	});

	final blog = new Blog("https://www.yourblog.com");
	new Client("123YourAPIKey", blog).checkComment(comment).handle(outcome -> switch outcome {
		case Success(result): trace(result == Ham ? "The comment is ham." : "The comment is spam.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
```

See the [API reference](https://cedx.github.io/akismet.hx/api) of this library for detailed information about the `Author` and `Comment` classes, and their properties.
