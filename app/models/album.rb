class Album
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title
	field :url
  field :widget_url
  field :upload_time
  field :tag

	has_many :beauties
end