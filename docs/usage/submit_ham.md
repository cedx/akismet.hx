# Submit ham
This call is intended for the submission of false positives - items that were incorrectly classified as spam by Akismet.
It takes identical arguments as [comment check](usage/check_comment.md) and [submit spam](usage/submit_spam.md).

```haxe
Client.submitHam(comment: Comment): Promise<Noise>
```

Remember that, as explained in the [submit spam](usage/submit_spam.md) documentation, you should ensure
that any values you're passing here match up with the original and corresponding [comment check](usage/check_comment.md) call.

See the [Akismet API documentation](https://akismet.com/developers/submit-ham-false-positives) for more information.

## Parameters

### **comment**: Comment
The user's `Comment` to be submitted, incorrectly classified as spam.

> Ideally, it should be the same object as the one passed to the original [comment check](usage/check_comment.md) API call.

## Return value
A `Promise` that resolves when the given `Comment` has been submitted.

The promise rejects with a `BadRequest` error when an issue occurs.
The error `message` usually includes some debug information, provided by the `X-akismet-debug-help` HTTP header,
about what exactly was invalid about the call.

It can also rejects with a custom error code and message (respectively provided by the `X-akismet-alert-code` and `X-akismet-alert-msg` headers).
See [Response Error Codes](https://akismet.com/developers/errors) for more information.

## Example

```haxe
import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;
using tink.CoreApi;

function main() {
  final blog = new Blog({url: "https://www.yourblog.com"});
  final client = new Client("123YourAPIKey", blog);

  final comment = new Comment({
    content: "I'm testing out the Service API.",
    author: new Author({
      ipAddress: "192.168.123.456",
      userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36"
    })
  });

  client.submitHam(comment).handle(outcome -> switch outcome {
    case Success(_): trace("The comment was successfully submitted as ham.");
    case Failure(error): trace('An error occurred: ${error.message}');
  });
}
```
