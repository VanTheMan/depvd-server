class Beauty
	include Mongoid::Document
	include Mongoid::Timestamps

	field :created_time
	field :url

	belongs_to :album
end