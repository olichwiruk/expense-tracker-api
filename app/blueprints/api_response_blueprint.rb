# frozen_string_literal: true

class ApiResponseBlueprint < Blueprinter::Base
  field :data do |object, options|
    blueprint = options[:blueprint]
    view = options[:data_view] || :default

    blueprint.render_as_hash(object, view: view)
  end
end
