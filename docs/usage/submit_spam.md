# Submit spam
This call is for submitting comments that weren't marked as spam but should have been.

```haxe
Client.submitSpam(comment: Comment): Promise<Noise>
```

It is very important that the values you submit with this call match those of your [comment check](usage/check_comment.md) calls as closely as possible.
In order to learn from its mistakes, Akismet needs to match your missed spam and false positive reports
to the original [comment check](usage/check_comment.md) API calls made when the content was first posted. While it is normal for less information
to be available for [submit spam](usage/submit_spam.md) and [submit ham](usage/submit_ham.md) calls (most comment systems and forums will not store all metadata),
you should ensure that the values that you do send match those of the original content.

See the [Akismet API documentation](https://akismet.com/developers/submit-spam-missed-spam) for more information.

## Parameters

### **comment**: Comment
The user's `Comment` to be submitted, incorrectly classified as ham.

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
```
