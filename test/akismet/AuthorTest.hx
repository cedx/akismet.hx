package akismet;

import haxe.DynamicAccess;

/** Tests the features of the `Author` class. **/
@:asserts class AuthorTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `toFormData()` method. **/
	public function testToFormData() {
		var data: DynamicAccess<String>;

		// It should return only the IP address and user agent with a newly created instance.
		data = new Author({ipAddress: "127.0.0.1", userAgent: "Doom/6.6.6"}).toFormData();
		asserts.assert(data.keys().length == 2);
		asserts.assert(data["user_agent"] == "Doom/6.6.6");
		asserts.assert(data["user_ip"] == "127.0.0.1");

		// It should return a non-empty map with an initialized instance.
		data = new Author({
			email: "cedric@belin.io",
			ipAddress: "192.168.0.1",
			name: "Cédric Belin",
			url: "https://belin.io",
			userAgent: "Mozilla/5.0"
		}).toFormData();

		asserts.assert(data.keys().length == 5);
		asserts.assert(data["comment_author"] == "Cédric Belin");
		asserts.assert(data["comment_author_email"] == "cedric@belin.io");
		asserts.assert(data["comment_author_url"] == "https://belin.io");
		asserts.assert(data["user_agent"] == "Mozilla/5.0");
		asserts.assert(data["user_ip"] == "192.168.0.1");

		return asserts.done();
	}
}
