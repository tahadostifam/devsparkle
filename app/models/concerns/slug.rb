module Slug
    def make_slug(ret)
        ret = ret.strip
        ret.gsub! /['`]/,""
        ret.gsub! "#", "sharp"
        ret.gsub! " ", "-"
        ret.gsub! /\s*@\s*/, " at "
        ret.gsub! /\s*&\s*/, " and "
        ret.gsub! /_+/,"_"
        ret.gsub! /\A[_\.]+|[_\.]+\z/,""
        ret
    end
end
