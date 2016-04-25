%dw 1.0
%output application/java
---
[{
	contributors: [1],
	createdAt: |2003-10-01|,
	currentUserRetweetId: 1,
	favorited: true,
	geoLocation: {
		latitude: 2,
		longitude: 2
	} as :object {
		class : "twitter4j.GeoLocation"
	},
	id: 1,
	inReplyToScreenName: "????",
	inReplyToStatusId: 1,
	inReplyToUserId: 1,
	place: {
		URL: "????",
		boundingBoxCoordinates: [[{
		} as :object {
			class : "twitter4j.GeoLocation"
		}]],
		boundingBoxType: "????",
		containedWithIn: [{
		} as :object {
			class : "twitter4j.Place"
		}],
		country: "????",
		countryCode: "????",
		fullName: "????",
		geometryCoordinates: [[{
		} as :object {
			class : "twitter4j.GeoLocation"
		}]],
		geometryType: "????",
		id: "????",
		name: "????",
		placeType: "????",
		streetAddress: "????",
		accessLevel: 1,
		rateLimitStatus: {
		} as :object {
			class : "twitter4j.RateLimitStatus"
		}
	} as :object {
		class : "twitter4j.Place"
	},
	possiblySensitive: true,
	retweet: true,
	retweetCount: 1,
	retweetedByMe: true,
	retweetedStatus: {
		contributors: [1],
		createdAt: |2003-10-01|,
		currentUserRetweetId: 1,
		favorited: true,
		geoLocation: {
		} as :object {
			class : "twitter4j.GeoLocation"
		},
		id: 1,
		inReplyToScreenName: "????",
		inReplyToStatusId: 1,
		inReplyToUserId: 1,
		place: {
		} as :object {
			class : "twitter4j.Place"
		},
		possiblySensitive: true,
		retweet: true,
		retweetCount: 1,
		retweetedByMe: true,
		source: "????",
		text: "????",
		truncated: true,
		user: {
		} as :object {
			class : "twitter4j.User"
		},
		accessLevel: 1,
		rateLimitStatus: {
		} as :object {
			class : "twitter4j.RateLimitStatus"
		},
		URLEntities: [{
		} as :object {
			class : "twitter4j.URLEntity"
		}],
		hashtagEntities: [{
		} as :object {
			class : "twitter4j.HashtagEntity"
		}],
		mediaEntities: [{
		} as :object {
			class : "twitter4j.MediaEntity"
		}],
		userMentionEntities: [{
		} as :object {
			class : "twitter4j.UserMentionEntity"
		}]
	} as :object {
		class : "twitter4j.Status"
	},
	source: "????",
	text: "????",
	truncated: true,
	user: {
		URL: "????",
		URLEntity: {
		} as :object {
			class : "twitter4j.URLEntity"
		},
		biggerProfileImageURL: "????",
		biggerProfileImageURLHttps: "????",
		contributorsEnabled: true,
		createdAt: |2003-10-01|,
		description: "????",
		descriptionURLEntities: [{
		} as :object {
			class : "twitter4j.URLEntity"
		}],
		favouritesCount: 1,
		followRequestSent: true,
		followersCount: 1,
		friendsCount: 1,
		geoEnabled: true,
		id: 1,
		lang: "????",
		listedCount: 1,
		location: "????",
		miniProfileImageURL: "????",
		miniProfileImageURLHttps: "????",
		name: "????",
		originalProfileImageURL: "????",
		originalProfileImageURLHttps: "????",
		profileBackgroundColor: "????",
		profileBackgroundImageURL: "????",
		profileBackgroundImageUrl: "????",
		profileBackgroundImageUrlHttps: "????",
		profileBackgroundTiled: true,
		profileBannerIPadRetinaURL: "????",
		profileBannerIPadURL: "????",
		profileBannerMobileRetinaURL: "????",
		profileBannerMobileURL: "????",
		profileBannerRetinaURL: "????",
		profileBannerURL: "????",
		profileImageURL: "????",
		profileImageURLHttps: "????",
		profileImageUrlHttps: {
		} as :object {
			class : "java.net.URL"
		},
		profileLinkColor: "????",
		profileSidebarBorderColor: "????",
		profileSidebarFillColor: "????",
		profileTextColor: "????",
		profileUseBackgroundImage: true,
		protected: true,
		screenName: "????",
		showAllInlineMedia: true,
		status: {
		} as :object {
			class : "twitter4j.Status"
		},
		statusesCount: 1,
		timeZone: "????",
		translator: true,
		utcOffset: 1,
		verified: true,
		accessLevel: 1,
		rateLimitStatus: {
		} as :object {
			class : "twitter4j.RateLimitStatus"
		}
	} as :object {
		class : "twitter4j.User"
	},
	accessLevel: 1,
	rateLimitStatus: {
		limit: 1,
		remaining: 1,
		remainingHits: 1,
		resetTimeInSeconds: 1,
		secondsUntilReset: 1
	} as :object {
		class : "twitter4j.RateLimitStatus"
	},
	URLEntities: [{
	} as :object {
		class : "twitter4j.URLEntity"
	}],
	hashtagEntities: [{
	} as :object {
		class : "twitter4j.HashtagEntity"
	}],
	mediaEntities: [{
	} as :object {
		class : "twitter4j.MediaEntity"
	}],
	userMentionEntities: [{
	} as :object {
		class : "twitter4j.UserMentionEntity"
	}]
} as :object {
	class : "twitter4j.Status"
}]