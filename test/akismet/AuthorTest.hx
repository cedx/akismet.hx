package akismet;

import akismet.Author.AuthorData;
import tink.Json;
import tink.QueryString;
import tink.url.Query;

/** Tests the features of the `Author` class. **/
@:asserts final class AuthorTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `fromJson()` method. **/
	public function fromJson() {
		var author: Author;

		author = Json.parse('{"user_ip": "192.168.0.1"}');
		asserts.assert(author.email.length == 0);
		asserts.assert(author.ipAddress == "192.168.0.1");
		asserts.assert(author.name.length == 0);
		asserts.assert((author.role: String).length == 0);
		asserts.assert(author.url == "");
		asserts.assert(author.userAgent.length == 0);

		author = Json.parse('{
			"comment_author": "Cédric Belin",
			"comment_author_email": "cedric@belin.io",
			"comment_author_url": "https://belin.io",
			"user_agent": "Mozilla/5.0",
			"user_ip": "127.0.0.1",
			"user_role": "administrator"
		}');

		asserts.assert(author.email == "cedric@belin.io");
		asserts.assert(author.ipAddress == "127.0.0.1");
		asserts.assert(author.name == "Cédric Belin");
		asserts.assert(author.role == Administrator);
		asserts.assert(author.url == "https://belin.io");
		asserts.assert(author.userAgent == "Mozilla/5.0");

		return asserts.done();
	}

	/** Tests the `toJson()` method. **/
	public function toJson() {
		var json: AuthorData;

		json = new Author({ipAddress: "127.0.0.1"}).toJson();
		asserts.assert(getFields(json).length == 1);
		asserts.assert(json.user_ip == "127.0.0.1");

		json = new Author({
			email: "cedric@belin.io",
			ipAddress: "192.168.0.1",
			name: "Cédric Belin",
			url: "https://belin.io",
			userAgent: "Mozilla/5.0"
		}).toJson();

		asserts.assert(getFields(json).length == 5);
		asserts.assert(json.comment_author == "Cédric Belin");
		asserts.assert(json.comment_author_email == "cedric@belin.io");
		asserts.assert(json.comment_author_url == "https://belin.io");
		asserts.assert(json.user_agent == "Mozilla/5.0");
		asserts.assert(json.user_ip == "192.168.0.1");

		return asserts.done();
	}

	/** Gets the fields of the specified form data. **/
	function getFields(formData: AuthorData): Array<String>
		return [for (param in Query.parseString(QueryString.build(formData))) param.name];
}
