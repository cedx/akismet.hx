package akismet;

/** Represents the author of a comment. **/
@:expose class Author #if php implements JsonSerializable<DynamicAccess<Any>> #end {

	/** The author's mail address. If you set it to `"akismet-guaranteed-spam@example.com"`, Akismet will always return `true`. **/
	public var email = "";

	/** The author's IP address. **/
	public var ipAddress: String;

	/** The author's name. If you set it to `"viagra-test-123"`, Akismet will always return `true`. **/
	public var name = "";

	/** The role of the author. If you set it to `"administrator"`, Akismet will always return `false`. **/
	public var role = "";

	/** The URL of the author's website. **/
	public var url = "";

	/** The author's user agent, that is the string identifying the Web browser used to submit comments. **/
	public var userAgent: String;

	/** Creates a new author. **/
	public function new(ipAddress: String, userAgent: String, ?options: #if php NativeStructArray<AuthorOptions> #else AuthorOptions #end) {
		this.ipAddress = ipAddress;
		this.userAgent = userAgent;

		if (options != null) {
			#if php
				if (isset(options["email"])) email = options["email"];
				if (isset(options["name"])) name = options["name"];
				if (isset(options["role"])) role = options["role"];
				if (isset(options["url"])) url = options["url"];
			#else
				if (options.email != null) email = options.email;
				if (options.name != null) name = options.name;
				if (options.role != null) role = options.role;
				if (options.url != null) url = options.url;
			#end
		}
	}

	/** Converts this object to a map in JSON format. **/
	public function toJson() {
		final map: DynamicAccess<Any> = {user_agent: userAgent, user_ip: ipAddress};
		if (name.length > 0) map["comment_author"] = name;
		if (email.length > 0) map["comment_author_email"] = email;
		if (url.length > 0) map["comment_author_url"] = url;
		if (role.length > 0) map["user_role"] = role;
		return map;
	}

	#if js
		/** Converts this object to a map in JSON format. **/
		public function toJSON() return toJson();
	#elseif php
		/** Converts this object to a map in JSON format. **/
		public function jsonSerialize() return toJson();
	#end
}

/** Defines the options of an `Author` instance. **/
typedef AuthorOptions = {

	/** The author's mail address. **/
	var ?email: String;

	/** The author's name. **/
	var ?name: String;

	/** The role of the author. **/
	var ?role: String;

	/** The URL of the author's website. **/
	var ?url: String;
}
