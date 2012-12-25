module MobileConcerns
  module Helpers
    def mobile_page_id(path = request.path)
      path.sub(/\A\/mobile\//,'').gsub("/",'_')
    end
  end
end

