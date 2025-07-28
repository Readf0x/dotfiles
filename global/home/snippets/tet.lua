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
  s("cc", {
    t({"<|"}),
    c(1, {
      sn(nil, { t(" "), r(1, "user_text"), t(" ") }),
      sn(nil, { t(":w "), r(1, "user_text"), t(" ") }),
      sn(nil, { t(":f "), r(1, "user_text"), t(" ") }),
      sn(nil, { t(":p "), r(1, "user_text"), t(" ") }),
      sn(nil, { t({"", "\t"}), r(1, "user_text"), t({"", ""}) }),
    }),
    t({"|>"}),
  }, {
    stored = {
      -- key passed to restoreNodes.
      ["user_text"] = i(1)
    }
  }),
}
