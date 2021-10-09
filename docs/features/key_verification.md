# Key verification
Key verification authenticates your API key before calling the [comment check](features/comment_check.md),
[submit spam](features/submit_spam.md) or [submit ham](features/submit_ham.md) methods.

```haxe
Client.verifyKey(): Promise<Bool>
```

This is the first call that you should make to Akismet and is especially useful
if you will have multiple users with their own Akismet subscriptions using your application.

See the [Akismet API documentation](https://akismet.com/development/api/#verify-key) for more information.

## Parameters
None.

## Return value
A `Promise` that resolves with a boolean value indicating whether the client's API key is valid.

The promise rejects with an `UnprocessableEntity` error when an issue occurs.
The error `message` usually includes some debug information, provided by the `X-akismet-debug-help` HTTP header,
about what exactly was invalid about the call.

## Example
```haxe
import akismet.Blog;
import akismet.Client;

using tink.CoreApi;

function main() {
	final blog = new Blog({url: "https://www.yourblog.com"});
	new Client("123YourAPIKey", blog).verifyKey().handle(outcome -> switch outcome {
		case Success(isValid): trace(isValid ? "The API key is valid." : "The API key is invalid.");
		case Failure(error): trace('An error occurred: ${error.message}');
	});
}
```

See the [API reference](https://cedx.github.io/akismet.hx/api) for detailed information
about the `Client` and `Blog` classes, and their properties and methods.
