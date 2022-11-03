-- Returns functions for looking up escape sequences.

local LookupTable = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&apos;",
    ["\n"] = "&#10;"
}

local Exports = {}

function Exports.GetEscapeSequence(char: string): string
    return LookupTable[char]
end

function Exports.GetOriginalCharacter(escapeSequence: string): string
    for char, sequence in pairs(LookupTable) do
        if sequence == escapeSequence then
            return char
        end
    end
end

function Exports.EscapeString(str: string): string
    -- First escape every & character, then escape every other character.
    -- This is to prevent the other characters from being escaped twice.
    return str:gsub("&", "&amp;"):gsub("[<>\n\"']", LookupTable)
end

function Exports.GetOriginalString(str: string): string
    return str:gsub("&#?[a-z0-9]+;", Exports.GetOriginalCharacter)
end

return Exports