class Album
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title
	field :url

	has_many :beauties
end