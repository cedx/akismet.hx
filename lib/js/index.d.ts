export declare class Author {
	email: string;
	ipAddress: string;
	name: string;
	role: string;
	url: string;
	userAgent: string;
	constructor(ipAddress: string, userAgent: string, options?: Partial<AuthorOptions>);
	toJSON(): Record<string, any>;
}

export interface AuthorOptions {
	email: string;
	name: string;
	role: string;
	url: string;
}

export declare class Blog {
	charset: string;
	languages: string[];
	url: string;
	constructor(url: string, options?: Partial<BlogOptions>);
	toJSON(): Record<string, any>;
}

export interface BlogOptions {
	charset: string;
	languages: string[];
}

export declare class Comment {
	author: Author;
	content: string;
	date?: Date;
	permalink: string;
	postModified?: Date;
	recheckReason: string;
	referrer: string;
	type: string;
	constructor(author: Author, options?: Partial<CommentOptions>);
	toJSON(): Record<string, any>;
}

export interface CommentOptions {
	content: string;
	date: Date;
	permalink: string;
	postModified: Date;
	recheckReason: string;
	referrer: string;
	type: string;
}
