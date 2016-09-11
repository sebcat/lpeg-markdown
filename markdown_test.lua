#!/usr/bin/env lua
-- vim: tabstop=2 shiftwidth=2 expandtab

md = require "markdown"

function expect(data, expected)
  actual = md.markdown(data)
  if actual ~=  expected then
    error(string.format("expected %q, was %q", expected, actual))
  else
    print(actual)
  end
end

-- h1
expect("#", "<h1></h1>")
expect("# ", "<h1></h1>")
expect("#Heading", "<h1>Heading</h1>")
expect("# \t Heading", "<h1>Heading</h1>")
expect("#Heading \t \n", "<h1>Heading</h1>")
expect("# Heading \n", "<h1>Heading</h1>")
expect("# Heading \n\n", "<h1>Heading</h1>")

-- h2
expect("##", "<h2></h2>")
expect("## ", "<h2></h2>")
expect("##Heading", "<h2>Heading</h2>")
expect("## Heading", "<h2>Heading</h2>")
expect("##Heading \n", "<h2>Heading</h2>")
expect("## Heading \n", "<h2>Heading</h2>")

-- h6
expect("######", "<h6></h6>")
expect("###### ", "<h6></h6>")
expect("######Heading", "<h6>Heading</h6>")
expect("###### Heading", "<h6>Heading</h6>")
expect("######Heading \n", "<h6>Heading</h6>")
expect("###### Heading \n", "<h6>Heading</h6>")

-- unordered lists (unnested)
expect("*", "<ul><li></li></ul>")
expect("* ", "<ul><li></li></ul>")
expect("*foo", "<ul><li>foo</li></ul>")
expect("* foo\n* bar", "<ul><li>foo</li><li>bar</li></ul>")
expect("* foo\n* bar\n", "<ul><li>foo</li><li>bar</li></ul>")
expect("*foo\n*bar", "<ul><li>foo</li><li>bar</li></ul>")

-- ordered lists (unnested)
expect("1.", "<ol><li></li></ol>")
expect("1. ", "<ol><li></li></ol>")
expect("1.foo", "<ol><li>foo</li></ol>")
expect("1. foo\n2. bar", "<ol><li>foo</li><li>bar</li></ol>")
expect("2. foo\n1. bar", "<ol><li>foo</li><li>bar</li></ol>")
expect("1. foo\n2. bar\n", "<ol><li>foo</li><li>bar</li></ol>")
expect("1.foo\n2.bar", "<ol><li>foo</li><li>bar</li></ol>")


-- paragraphs
expect("What a lovely day", "<p>What a lovely day</p>")
expect("What a \nlovely day", "<p>What a \nlovely day</p>")
expect("\r\nWhat a lovely day\n\nInnit?", "<p>What a lovely day</p><p>Innit?</p>")

expect([[
#The party

Once, there was a party.

There was:

* food, and
* drinks

I

1. ate, and
2. I drank]], "<h1>The party</h1><p>Once, there was a party.</p><p>There was:</p><ul><li>food, and</li><li>drinks</li></ul><p>I</p><ol><li>ate, and</li><li>I drank</li></ol>")

