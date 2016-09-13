#!/usr/bin/env lua
-- vim: tabstop=2 shiftwidth=2 expandtab

markdown = require "markdown"

function expect(data, expected)
  actual = markdown.parse(data)
  if actual ~=  expected then
    error(string.format("expected %q, was %q", expected, actual))
  else
    print(actual)
  end
end

local startt = os.clock()

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
expect("What a \nlovely day", "<p>What a lovely day</p>")
expect("\r\nWhat a lovely day\n\nInnit?", "<p>What a lovely day</p><p>Innit?</p>")

-- links
expect("Hello good sir/madam\n\nVisit [example](http://example.com/) or dont", "<p>Hello good sir/madam</p><p>Visit <a href=\"http://example.com/\">example</a> or dont</p>")

-- text attributes
expect("Say *foo bar*", "<p>Say <em>foo bar</em></p>")
expect("foo **foo*bar**", "<p>foo <strong>foo*bar</strong></p>")
expect("foo `  *foo*bar  `", "<p>foo <code>*foo*bar</code></p>")

expect([[
#The party

Once, there was a **party**.

There was:

* *food*, and
* *drinks*

I

1. *ate*, and
2. I *drank*

After the party, someone showed me the following code:

````
import gravity
````

He even gave me his [e-mail](mailto:foo@example.com)
]], "<h1>The party</h1><p>Once, there was a <strong>party</strong>.</p><p>There was:</p><ul><li><em>food</em>, and</li><li><em>drinks</em></li></ul><p>I</p><ol><li><em>ate</em>, and</li><li>I <em>drank</em></li></ol><p>After the party, someone showed me the following code:</p><pre><code>import gravity\n</code></pre><p>He even gave me his <a href=\"mailto:foo@example.com\">e-mail</a></p>")
print("CPU time: "..tostring((os.clock()-startt)*1000).."ms")
