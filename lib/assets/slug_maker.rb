def to_slug(val)
    ret = val.strip
    ret.gsub! /['`]/,""
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'
    ret.gsub! /_+/,"_"
    ret.gsub! /\A[_\.]+|[_\.]+\z/,""
    ret
end