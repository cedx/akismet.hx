package akismet;

/** Tests the features of the `Client` class. **/
@:asserts class ClientTest {

	/** The client used to query the service database. **/
	final client = new Client(
		Sys.getEnv("AKISMET_API_KEY"),
		new Blog({url: "https://cedx.github.io/akismet.hx"}),
		{isTest: true}
	);

	/** A comment with content marked as ham. **/
	final ham = new Comment({
		author: new Author({
			ipAddress: "192.168.0.1",
			name: "Akismet",
			role: Administrator,
			url: "https://cedx.github.io/akismet.hx",
			userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36 Edg/94.0.992.38"
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
	@:timeout(15000)
	public function testCheckComment() {
		Promise.inParallel([
			client.checkComment(ham).next(result -> asserts.assert(result == Ham)),
			client.checkComment(spam).next(result -> asserts.assert([CheckResult.Spam, CheckResult.PervasiveSpam].contains(result)))
		]).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `submitHam()` method. **/
	@:timeout(15000)
	public function testSubmitHam() {
		client.submitHam(ham).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `submitSpam()` method. **/
	@:timeout(15000)
	public function testSubmitSpam() {
		client.submitSpam(spam).handle(asserts.handle);
		return asserts;
	}

	/** Tests the `verifyKey()` method. **/
	@:timeout(15000)
	public function testVerifyKey() {
		Promise.inParallel([
			client.verifyKey().next(isValid -> asserts.assert(isValid)),
			new Client("0123456789-ABCDEF", client.blog, {isTest: true}).verifyKey().next(isValid -> asserts.assert(!isValid))
		]).handle(asserts.handle);

		return asserts;
	}
}
