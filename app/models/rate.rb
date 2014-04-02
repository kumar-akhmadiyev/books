class Rate
	include Mongoid::Document
	include Mongoid::Timestamps

	RATING = [0,1,2,3,4,5]

	field :points, type: Integer, default: 0

	belongs_to :book


end