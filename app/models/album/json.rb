module Album::Json
  extend ActiveSupport::Concern

  included do
    include Mongoid::CachedJson

    json_fields \
      id: { },
      title: { },
      url: { },
      widget_url: { },
      upload_time: { },
      tag: { },
      created_at: { }
  end

  def as_json_details
    as_json.merge(photos: beauties.as_json)
  end
end