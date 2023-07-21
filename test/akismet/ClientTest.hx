package akismet;

/** Tests the features of the `Client` class. **/
@:asserts final class ClientTest {

	/** The client used to query the service database. **/
	final client = new Client(
		Sys.getEnv("AKISMET_API_KEY"),
		new Blog({url: "https://github.com/cedx/akismet.hx"}),
		{isTest: true}
	);

	/** A comment with content marked as ham. **/
	final ham = new Comment({
		author: new Author({
			ipAddress: "192.168.0.1",
			name: "Akismet",
			role: Administrator,
			url: "https://belin.io",
			userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0"
		}),
		content: "I'm testing out the Service API.",
		referrer: "https://lib.haxe.org/p/akismet",
		type: Comment
	});

	/** A comment with content marked as spam. **/
	final spam = new Comment({
		author: new Author({
			ipAddress: "127.0.0.1",
			email: "akismet-guaranteed-spam@example.com",
			name: "viagra-test-123",
			userAgent: "Spam Bot/6.6.6"
		}),
		content: "Spam!",
		type: BlogPost
	});

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `checkComment()` method. **/
	@:timeout(15_000)
	public function checkComment() {
		Promise.inParallel([
			client.checkComment(ham).next(result -> asserts.assert(result == Ham)),
			client.checkComment(spam).next(result -> asserts.assert([CheckResult.Spam, CheckResult.PervasiveSpam].contains(result)))
		]).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `submitHam()` method. **/
	@:timeout(15_000)
	public function submitHam() {
		client.submitHam(ham).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `submitSpam()` method. **/
	@:timeout(15_000)
	public function submitSpam() {
		client.submitSpam(spam).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `verifyKey()` method. **/
	@:timeout(15_000)
	public function verifyKey() {
		Promise.inParallel([
			client.verifyKey().next(isValid -> asserts.assert(isValid)),
			new Client("0123456789-ABCDEF", client.blog, {isTest: true}).verifyKey().next(isValid -> asserts.assert(!isValid))
		]).handle(asserts.handle);

		return asserts;
	}
}
