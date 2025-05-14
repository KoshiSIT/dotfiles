local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    s("atcoder", {
        t({
            "use proconio::input;",
            "",
            "fn main() {",
            "    input! {",
            "",
            "    }",
            "}",
        }),
    })
}
