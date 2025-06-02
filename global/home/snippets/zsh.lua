local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local wide_in = "        "

local function id(text)
  return '\t\t| ' .. text
end

local new_usage
new_usage = function(args, _,_, user_args)
  return sn(nil, {
    c(1, {
      i(nil),
      sn(nil, {
        t({"", id("       %B")}), i(1, args[1][1]), t("%b "), i(2, "[OPTIONS]"), d(3, new_usage, {1})
      })
    })
  })
end

local new_arg
new_arg = function()
  return sn(nil, {
    c(1, {
      t(""),
      sn(nil, {
        t("\t%B"), i(1, "[ARG]"), t("%b"),
        t({"", id(wide_in)}), i(2, "Description"),
        t({"", id("")}),
        d(3, new_arg),
      }),
    }),
  })
end

return {
  s("help", {
    t({"function help() {", "\tmsg=\"$(sed -e 's/^[ ]*| //m' <<'--------------------'"}),
    t({"", id("")}), i(1, "Description"),
    t({"", id(""), id("%UUsage:%u %B")}), i(2, vim.fn.expand("%:t")), t("%b "), i(3, "[OPTIONS]"), d(4, new_usage, {2}),
    t({"", id(""), id("%UArguments:%u")}),
    t({"", id("")}), d(5, new_arg),
    t({"", id("%UOptions:%u"), id("\t%B-h%b, %B--help%b:")}),
    t({"", id(wide_in)}), c(6, {
      t("Print help"),
      sn(nil, { t("Print help "), i(1, "(see a summary with %B-h%b)") }),
    }),
    t({"", "--------------------", "\t\t)\"", "\tprint -P $msg", "}"}), i(0)
  })
}

