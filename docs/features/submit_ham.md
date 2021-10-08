# Submit ham
This call is intended for the submission of false positives - items that were incorrectly classified as spam by Akismet.
It takes identical arguments as [comment check](features/comment_check.md) and [submit spam](features/submit_spam.md).

```haxe
Client.submitHam(comment: Comment): Promise<Noise>
```

Remember that, as explained in the [submit spam](features/submit_spam.md) documentation, you should ensure
that any values you're passing here match up with the original and corresponding [comment check](features/comment_check.md) call.

See the [Akismet API documentation](https://akismet.com/development/api/#submit-ham) for more information.

## Parameters

### **comment**: Comment
The user's `Comment` to be submitted, incorrectly classified as spam.

?> Ideally, it should be the same object as the one passed to the original [comment check](features/comment_check.md) API call.

## Return value
A `Promise` that resolves when the given `Comment` has been submitted.

The promise rejects with an `UnprocessableEntity` error when an issue occurs.
The error `message` usually includes some debug information, provided by the `X-akismet-debug-help` HTTP header,
about what exactly was invalid about the call.

## Example

```haxe
import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;

using tink.CoreApi;

function main() {
	final comment = new Comment({
		author: new Author({ipAddress: "127.0.0.1", userAgent: "Mozilla/5.0"}),
		content: "A valid user comment (i.e. ham)"
	});

	final blog = new Blog("https://www.yourblog.com");
	new Client("123YourAPIKey", blog).checkComment(comment)
		.next(result -> {
			// Got `CheckResult.Spam`, but `CheckResult.Ham` expected.
			trace("The comment was incorrectly classified as spam.");
			client.submitHam(comment);
		})
		.handle(outcome -> switch outcome {
			case Success(_): trace("The comment was successfully submitted as ham.");
			case Failure(error): trace('An error occurred: ${error.message}');
		});
}
```
