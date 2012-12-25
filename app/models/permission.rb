module Permission
  def initialize(options = {})
    custom_options = [
    [:editable, 'Boolean', true]
  ]
    acts_as_custom_options custom_options
  end

  class_eval %(
    def editable?
      editable
    end
  )
end

