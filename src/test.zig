const std = @import("std");
const i18n_mod = @import("core/i18n/mod.zig");
const root_file = @import("root.zig");
const bcrypt_mod = @import("features/auth/bcrypt.zig");

test {
    _ = i18n_mod;
    _ = root_file;
    _ = bcrypt_mod;
    _ = std;
}
