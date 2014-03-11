class Beauty
	include Mongoid::Document
	include Mongoid::Timestamps

	field :url

	belongs_to :album
end