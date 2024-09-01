package akismet;

import coconut.data.Model;
import tink.Url;

/** Represents the author of a comment. **/
@:jsonParse(akismet.Author.fromJson)
@:jsonStringify(author -> author.toJson())
class Author implements Model {

	/** The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `true`. **/
	@:editable var email: String = @byDefault "";

	/** The author's IP address. **/
	@:editable var ipAddress: String;

	/** The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `true`. **/
	@:editable var name: String = @byDefault "";

	/** The author's role. If you set it to `"administrator"`, Akismet will always return `false`. **/
	@:editable var role: AuthorRole = @byDefault "";

	/** The URL of the author's website. **/
	@:editable var url: Null<Url> = @byDefault null;

	/** The author's user agent, that is the string identifying the Web browser used to submit comments. **/
	@:editable var userAgent: String = @byDefault "";

	/** Creates a new author from the specified JSON object. **/
	public static function fromJson(json: AuthorData): Author
		return new Author({
			email: json.comment_author_email,
			ipAddress: json.user_ip,
			name: json.comment_author,
			role: json.user_role,
			url: json.comment_author_url,
			userAgent: json.user_agent
		});

	/** Converts this object to a map in JSON format. **/
	public function toJson(): AuthorData
		return {
			comment_author: name.length > 0 ? name : null,
			comment_author_email: email.length > 0 ? email : null,
			comment_author_url: url != null ? url : null,
			user_agent: userAgent.length > 0 ? userAgent : null,
			user_ip: ipAddress,
			user_role: (role: String).length > 0 ? role : null
		};
}

/** Defines the data of an author. **/
typedef AuthorData = {

	/** The author's name. **/
	var ?comment_author: String;

	/** The author's mail address. **/
	var ?comment_author_email: String;

	/** The URL of the author's website. **/
	var ?comment_author_url: String;

	/** The author's user agent. **/
	var ?user_agent: String;

	/** The author's IP address. **/
	var user_ip: String;

	/** The author's role. **/
	var ?user_role: String;
}

/** Specifies the role of an author. **/
enum abstract AuthorRole(String) from String to String {

	/** The author is an administrator. **/
	var Administrator = "administrator";
}
