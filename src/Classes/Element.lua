--!strict
-- Class representing a single XML element

local Element = {}
Element.__index = Element

local EscapeLookup = require(script.Parent.Parent.EscapeLookup)

function Element.new(name: string, attributes: Attributes, content: Content)
    local self = setmetatable({}, Element)
    self.name = name or ""
    self.attributes = attributes
    self.content = content
    return self
end

function Element.__tostring(self)
    local attributes = ""
    for name, value in pairs(self.attributes) do
        attributes ..= " "..string.format("%s=%q", EscapeLookup.EscapeString(name), EscapeLookup.EscapeString(value))
    end

    local content = ""
    for _, child in ipairs(self.content) do
        content ..= tostring(child)
    end

    return string.format("<%s%s>%s</%s>", EscapeLookup.EscapeString(self.name), attributes, content, EscapeLookup.EscapeString(self.name))
end

-- Returns the element and its content as a string with indentation.
function Element:GetFormatted(indentSize: number): string
    print("Formatting", self.name)
    indentSize = indentSize or 4
    local indent = string.rep(" ", indentSize)
    local attributes = ""
    for name, value in pairs(self.attributes) do
        attributes ..= " "..string.format("%s=%q", EscapeLookup.EscapeString(name), EscapeLookup.EscapeString(value))
    end

    local content = ""
    for _, child in ipairs(self.content) do
        content ..= string.format(
            "\n%s%s",
            indent,
            if typeof(child) == typeof(Element.new("", {}, {})) then
                table.concat(child:GetFormatted(indentSize):split("\n"), "\n"..indent)
            else
                tostring(child)
        )
    end

    return string.format("<%s%s>%s\n</%s>", EscapeLookup.EscapeString(self.name), attributes, content, EscapeLookup.EscapeString(self.name))
end

-- Type definitions
export type Attributes = { [string]: string }
export type Content = { typeof(Element.new) | string }
export type Element = typeof(Element.new)

return Element