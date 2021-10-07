# Key verification
Key verification authenticates your key before calling the [comment check](comment_check.md),
[submit spam](submit_spam.md) or [submit ham](submit_ham.md) methods.

```javascript
Client.verifyKey(): Promise<boolean>
```

This is the first call that you should make to Akismet and is especially useful
if you will have multiple users with their own Akismet subscriptions using your application.

See the [Akismet API documentation](https://akismet.com/development/api/#verify-key) for more information.

## Parameters
None.

## Return value
A `Promise` that resolves with a `boolean` value indicating whether the client's API key is valid.

The promise rejects with a `ClientError` exception when an error occurs.
The exception `message` usually includes some debug information, provided by the `X-akismet-debug-help` HTTP header, about what exactly was invalid about the call.

## Example

```javascript
import {Blog, Client} from "@cedx/akismet";

async function main() {
	try {
		const blog = new Blog(new URL("https://www.yourblog.com"));
		const client = new Client("123YourAPIKey", blog);

		const isValid = await client.verifyKey();
		console.log(isValid ? "The API key is valid." : "The API key is invalid.");
	}
		
	catch (err) {
		console.log(`An error occurred: ${err.message}`);
	}
}
```

See the [API reference](https://cedx.github.io/akismet.js/api) for detailed information about the `Client` and `Blog` classes, and their properties and methods.
