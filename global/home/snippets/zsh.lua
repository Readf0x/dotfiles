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
new_usage = function(args)
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

local new_option
new_option = function()
  return sn(nil, {
    c(1, {
      t(""),
      sn(nil, {
        t({"", id("\t%B")}), c(1, {
          sn(nil, { t("--"), i(1, "flag") }),
          sn(nil, { t("-"), i(1, "f") }),
          sn(nil, { t("-"), i(1, "f"), t("%b, %B--"), i(2, "flag") })
        }), t({"%b:", id(wide_in)}), i(2, "Description"),
        d(3, new_option)
      })
    })
  })
end

local new_opt_case
new_opt_case = function()
  return sn(nil, {
    c(1, {
      t(""),
      sn(nil, {
        t({"", "\t\t\t--"}), i(1, "opt"), t")",
        t({"", wide_in}), c(2, {
          i(nil, "flag"),
          i(nil, "flag=true"),
          i(nil, "flag=1"),
          i(nil, "flag=${@[$((${@[(Ie)$opt]}+1))]}")
        }),
        t({"", wide_in .. ";;"}),
        d(3, new_opt_case)
      })
    })
  })
end

local new_o_case
new_o_case = function()
  return sn(nil, {
    c(1, {
      t(""),
      sn(nil, {
        t({"", wide_in}), i(1, "o"), t")",
        t({"", wide_in .. "\t"}), c(2, {
          i(nil, "flag"),
          i(nil, "flag=true"),
          i(nil, "flag=1"),
          i(nil, "flag=${@[$((${@[(Ie)$opt]}+1))]}")
        }),
        t({"", wide_in .. "\t;;"}),
        d(3, new_o_case)
      })
    })
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
      i(1, "Print help (see a summary with %B-h%b)")
    }),
    d(7, new_option),
    t({"", "--------------------", "\t\t)\"", "\tprint -P $msg", "}"}), i(0)
  }),

  s("args", {
    t({
      "for opt in $@; do",
      "\tif [[ $opt =~ ^-- ]]; then",
      "\t\t$opt in",
      "\t\t\t--"
    }), i(1, "help"), t(")"),
    t({"", wide_in}), i(2, "help"),
    t({"", wide_in .. ";;"}), d(3, new_opt_case),
    t({"",
      "\t\tesac",
      "\telif [[ $opt =~ ^- ]]; then",
      "\t\tfor char in $(print ${opt#\"-\"} | fold -w1); do",
      "\t\t\tcase $char in", wide_in
    }), i(4, "h"), t")",
    t({"", wide_in .. "\t"}), i(5, "help"),
    t({"", wide_in .. "\t;;"}),
    d(6, new_o_case), t({"",
      "\t\t\tesac",
      "\t\tdone",
      "\tfi",
      "done"
    })
  })
}

