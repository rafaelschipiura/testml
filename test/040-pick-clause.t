#!/usr/bin/env testml-boot

Diff = 1
*input.compile == *output

=== Point as call arg
--- input
(*d, !*e) *a.add(*b) == *c

--- output
{ "testml": "0.3.0",
  "code": ["=>",[],
    ["%()",["*d","!*e","*a","*b","*c"],
      ["==",
        [".",
          ["*","a"],
          ["add",
            ["*","b"]]],
        ["*","c"]]]],
  "data": []}

# vim: ft=:
