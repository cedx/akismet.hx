package akismet;

#if nodejs
import js.Node.process;
#end

using thenshim.PromiseTools;

/** Tests the features of the `Client` class. **/
class ClientTest extends Test {

	/** The client used to query the service database. **/
	var client(default, null): Client;

	/** A comment with content marked as ham. **/
	var ham(default, null): Comment;

	/** A comment with content marked as spam. **/
	var spam(default, null): Comment;

	/** This method is executed once before running the first test in the current class. **/
	function setupClass() {
		final apiKey = #if nodejs process.env["AKISMET_API_KEY"] #else Sys.getEnv("AKISMET_API_KEY") #end;
		client = new Client(apiKey, new Blog("https://docs.belin.io/akismet.hx"), {isTest: true});

		var author = new Author("192.168.0.1", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0", {
			name: "Akismet",
			role: "administrator",
			url: "https://docs.belin.io/akismet.hx"
		});

		ham = new Comment(author, {
			content: "I'm testing out the Service API.",
			referrer: "https://lib.haxe.org/p/akismet",
			type: CommentType.Comment
		});

		author = new Author("127.0.0.1", "Spam Bot/6.6.6", {
			email: "akismet-guaranteed-spam@example.com",
			name: "viagra-test-123"
		});

		spam = new Comment(author, {
			content: "Spam!",
			type: CommentType.Trackback
		});
	}

	/** Tests the `checkComment()` method. **/
	@:timeout(15000)
	function testCheckComment(async: Async) {
		// It should return `CheckResult.IsHam` for valid comment (e.g. ham).
		async.branch(branch -> client.checkComment(ham)
			.then(result -> Assert.equals(CheckResult.IsHam, result))
			.catchError(e -> Assert.fail(Std.string(e)))
			.finally(() -> branch.done())
		);

		// It should return `CheckResult.IsSpam` for invalid comment (e.g. spam).
		async.branch(branch -> client.checkComment(spam)
			.then(result -> Assert.allows([CheckResult.IsSpam, CheckResult.IsPervasiveSpam], result))
			.catchError(e -> Assert.fail(Std.string(e)))
			.finally(() -> branch.done())
		);
	}

	/** Tests the `submitHam()` method. **/
	@:timeout(15000)
	function testSubmitHam(async: Async) {
		// It should complete without any error.
		client.submitHam(ham)
			.then(_ -> Assert.pass())
			.catchError(e -> Assert.fail(Std.string(e)))
			.finally(() -> async.done());
	}

	/** Tests the `submitSpam()` method. **/
	@:timeout(15000)
	function testSubmitSpam(async: Async) {
		// It should complete without any error.
		client.submitSpam(spam)
			.then(_ -> Assert.pass())
			.catchError(e -> Assert.fail(Std.string(e)))
			.finally(() -> async.done());
	}

	/** Tests the `verifyKey()` method. **/
	@:timeout(15000)
	function testVerifyKey(async: Async) {
		// It should return `true` for a valid API key.
		async.branch(branch -> client.verifyKey()
			.then(result -> Assert.isTrue(result))
			.catchError(e -> Assert.fail(Std.string(e)))
			.finally(() -> branch.done())
		);

		// It should return `false` for an invalid API key.
		final anotherClient = new Client("0123456789-ABCDEF", client.blog, {isTest: true});
		async.branch(branch -> anotherClient.verifyKey()
			.then(result -> Assert.isFalse(result))
			.catchError(e -> Assert.fail(Std.string(e)))
			.finally(() -> branch.done())
		);
	}
}
