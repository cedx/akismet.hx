package akismet;

using Lambda;

/** Tests the features of the `Author` class. **/
@:asserts class AuthorTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `toMap()` method. **/
	public function testToMap() {
		// It should return only the IP address and user agent with a newly created instance.
		var map = new Author({ipAddress: "127.0.0.1", userAgent: "Doom/6.6.6"}).toMap();
		asserts.assert(map.count() == 2);
		asserts.assert(map["user_agent"] == "Doom/6.6.6");
		asserts.assert(map["user_ip"] == "127.0.0.1");

		// It should return a non-empty map with an initialized instance.
		map = new Author({
			email: "cedric@belin.io",
			ipAddress: "192.168.0.1",
			name: "Cédric Belin",
			url: "https://belin.io",
			userAgent: "Mozilla/5.0"
		}).toMap();

		asserts.assert(map.count() == 5);
		asserts.assert(map["comment_author"] == "Cédric Belin");
		asserts.assert(map["comment_author_email"] == "cedric@belin.io");
		asserts.assert(map["comment_author_url"] == "https://belin.io");
		asserts.assert(map["user_agent"] == "Mozilla/5.0");
		asserts.assert(map["user_ip"] == "192.168.0.1");

		return asserts.done();
	}
}
