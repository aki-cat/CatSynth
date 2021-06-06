-- Luacheck config file
files["**/spec/**/*_spec.lua"].std = "+busted"
files["**/test/**/*_spec.lua"].std = "+busted"
files["**/tests/**/*_spec.lua"].std = "+busted"
files["**/*.luacheckrc"].std = "+luacheckrc"

globals = {
    "love",
    "printf",
    "TABLE",
    "FUNCTION",
    "NUMBER",
    "STRING",
    "THREAD",
    "USERDATA",
    "NULL"
}
