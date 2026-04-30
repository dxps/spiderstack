const std = @import("std");
const spider = @import("spider");
const google = spider.google;

pub fn fetchGoogleProfile(
    c: *spider.Ctx,
    code: []const u8,
    config: google.GoogleConfig,
) !google.GoogleProfile {
    return google.fetchProfile(c, code, config);
}
