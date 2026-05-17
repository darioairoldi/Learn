-- mermaid-codeblock.lua
-- Converts ```mermaid code blocks into rendered Mermaid diagrams
-- so they render on the Quarto site while keeping GitHub-compatible
-- ```mermaid syntax in source files.
--
-- Mermaid.js is loaded via include-after-body in _quarto.yml.

function CodeBlock(el)
  if el.classes:includes("mermaid") then
    return pandoc.RawBlock("html",
      "<pre class=\"mermaid\">\n" .. el.text .. "\n</pre>")
  end
end
