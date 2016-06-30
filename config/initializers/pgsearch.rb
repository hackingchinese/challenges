PgSearch.multisearch_options = {
  :using => {
    :tsearch => {
      dictionary: 'english',
      :prefix => true
    },
    :trigram => {}
  },
  :ignoring => :accents
}
