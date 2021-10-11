module URI
    def self.escape(string)
        return URI.decode_www_form_component(string)
    end
end