if defined?(Footnotes) && Rails.env.development?
  # Footnotes::Filter.prefix = 'txmt://open?url=file://%s&amp;line=%d&amp;column=%d'
  Footnotes.run! # first of all
  Footnotes::Filter.prefix = 'gedit://open?url=file://%s'#&amp;line=%d&amp;column=%d'
  # ... other init code
  Footnotes::Filter.notes = [:session, :cookies, :params, :filters, :routes, :env, :queries, :log, :general]
end

