local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

return {
  s("e", {
    t("enable = true;")
  }),
  s("ed", {
    t(".enable = true;")
  }),
  s("ea", {
    t({" = {", "\tenable = true;"}),
    t({"", "\t"}), i(1),
    t({"", "};"})
  }),
  s("\'\'", {
    t({"\'\'"}),
    t({"", "\t"}), i(1),
    t({"", "\'\'"})
  }),
}
