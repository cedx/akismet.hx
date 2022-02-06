package akismet;

import coconut.data.Model;
import tink.Url;

/** Represents the author of a comment. **/
#if tink_json
@:jsonParse(json -> new akismet.Author(json))
@:jsonStringify(author -> {
	email: author.email,
	ipAddress: author.ipAddress,
	name: author.name,
	role: author.role,
	url: author.url,
	userAgent: author.userAgent
})
#end
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
	@:editable var userAgent: String;

	/** Converts this object to a map. **/
	public function toMap() {
		final map: Map<String, String> = ["user_agent" => userAgent, "user_ip" => ipAddress];
		if (email.length > 0) map["comment_author_email"] = email;
		if (name.length > 0) map["comment_author"] = name;
		if ((role: String).length > 0) map["user_role"] = role;
		if (url != null) map["comment_author_url"] = url;
		return map;
	}
}

/** Specifies the role of an author. **/
enum abstract AuthorRole(String) from String to String {

	/** The author is an administrator. **/
	var Administrator = "administrator";
}
