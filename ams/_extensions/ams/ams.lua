

local function endTypstBlock(blocks)
  local lastBlock = blocks[#blocks]
  if lastBlock.t == "Para" or lastBlock.t == "Plain" then
    lastBlock.content:insert(pandoc.RawInline('typst', '\n]'))
    return blocks
  else
    blocks:insert(pandoc.RawBlock('typst', ']\n'))
    return blocks
  end
end

function Div(el)
  if el.classes:includes('ams-theorem') then
    local args = ''
    if el.attributes['numbered'] == "false" then
      args = '(numbered: false)'
    end
    local blocks = pandoc.List({
      pandoc.RawBlock('typst', '#theorem' .. args .. '[')
    })
    blocks:extend(el.content)
    return endTypstBlock(blocks)
  elseif el.classes:includes('ams-proof') then
    local blocks = pandoc.List({
      pandoc.RawBlock('typst', '#proof[')
    })
    blocks:extend(el.content)
    return endTypstBlock(blocks)
  end
end

