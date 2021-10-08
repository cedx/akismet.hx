# Submit spam (missed spam)
This call is for submitting comments that weren't marked as spam but should have been.

```haxe
Client.submitSpam(comment: Comment): Promise<Noise>
```

It is very important that the values you submit with this call match those of your [comment check](features/comment_check.md) calls as closely as possible.
In order to learn from its mistakes, Akismet needs to match your missed spam and false positive reports
to the original [comment check](features/comment_check.md) API calls made when the content was first posted. While it is normal for less information
to be available for [submit spam](features/submit_spam.md) and [submit ham](features/submit_ham.md) calls (most comment systems and forums will not store all metadata),
you should ensure that the values that you do send match those of the original content.

See the [Akismet API documentation](https://akismet.com/development/api/#submit-spam) for more information.

## Parameters

### **comment**: Comment
The user's `Comment` to be submitted, incorrectly classified as ham.

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
		content: "An invalid user comment (i.e. spam)"
	});

	final blog = new Blog({url: "https://www.yourblog.com"});
	new Client("123YourAPIKey", blog).checkComment(comment)
		.next(result -> {
			// Got `CheckResult.Ham`, but `CheckResult.Spam` expected.
			trace("The comment was incorrectly classified as ham.");
			client.submitSpam(comment);
		})
		.handle(outcome -> switch outcome {
			case Success(_): trace("The comment was successfully submitted as spam.");
			case Failure(error): trace('An error occurred: ${error.message}');
		});
}
```
