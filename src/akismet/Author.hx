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

	/** Converts this object to form data. **/
	public function toFormData() {
		final data: AuthorFormData = {user_agent: userAgent, user_ip: ipAddress};
		if (email.length > 0) data.comment_author_email = email;
		if (name.length > 0) data.comment_author = name;
		if ((role: String).length > 0) data.user_role = role;
		if (url != null) data.comment_author_url = url;
		return data;
	}
}

/** Defines the form data of an author. **/
typedef AuthorFormData = {

	/** The author's name. **/
	var ?comment_author: String;

	/** The author's mail address. **/
	var ?comment_author_email: String;

	/** The URL of the author's website. **/
	var ?comment_author_url: String;

	/** The author's user agent. **/
	var user_agent: String;

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
