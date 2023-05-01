
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
    blocks:insert(pandoc.RawBlock('typst', ']\n'))
    return blocks
  elseif el.classes:includes('ams-proof') then
    local blocks = pandoc.List({
      pandoc.RawBlock('typst', '#proof[')
    })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', ']\n'))
    return blocks
  end
end