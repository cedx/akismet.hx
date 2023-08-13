# Testing
When you will integrate this library with your own application, you will of course need to test it.
Often we see developers get ahead of themselves, making a few trivial API calls with minimal values
and drawing the wrong conclusions about Akismet's accuracy.

## Simulate a positive result (spam)
Make a [comment check](usage/check_comment.md) API call with the `Author.name` set to `"viagra-test-123"`
or `Author.email` set to `"akismet-guaranteed-spam@example.com"`. Populate all other required fields with typical values.

The Akismet API will always return a `CheckResult.Spam` response to a valid request with one of those values.
If you receive anything else, something is wrong in your client, data, or communications.

```haxe
import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;

function main() {
  final comment = new Comment({
    content: "A user comment.",
    author: new Author({
      ipAddress: "127.0.0.1",
      name: "viagra-test-123",
      userAgent: "Mozilla/5.0"
    })
  });

  new Client("123YourAPIKey", new Blog({url: "https://www.yourblog.com"}))
    .checkComment(comment)
    .next(result -> trace('It should be "CheckResult.Spam": $result'));
}
```

## Simulate a negative result (ham)
Make a [comment check](usage/check_comment.md) API call with the `Author.role` set to `"administrator"`
and all other required fields populated with typical values.

The Akismet API will always return a `CheckResult.Ham` response. Any other response indicates a data or communication problem.

```haxe
import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;

function main() {
  final comment = new Comment({
    content: "A user comment.",
    author: new Author({
      ipAddress: "127.0.0.1",
      role: Administrator,
      userAgent: "Mozilla/5.0"
    })
  });

  new Client("123YourAPIKey", new Blog({url: "https://www.yourblog.com"}))
    .checkComment(comment)
    .next(result -> trace('It should be "CheckResult.Ham": $result'));
}
```

## Automated testing
Enable the `Client.isTest` option in your tests.

That will tell Akismet not to change its behaviour based on those API calls: they will have no training effect.
That means your tests will be somewhat repeatable, in the sense that one test won't influence subsequent calls.

```haxe
import akismet.Author;
import akismet.Blog;
import akismet.Client;
import akismet.Comment;

function main() {
  final blog = new Blog({url: "https://www.yourblog.com"});
  final client = new Client("123YourAPIKey", blog, {isTest: true});

  final comment = new Comment({
    content: "A user comment.",
    author: new Author({ipAddress: "127.0.0.1", userAgent: "Mozilla/5.0"})
  });

  // It should not influence subsequent calls.
  client.checkComment(comment);
}
```
