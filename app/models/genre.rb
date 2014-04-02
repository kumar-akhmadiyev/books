class Genre
	include Mongoid::Document

	field :title, type: String, default: ""

	has_many :books

end