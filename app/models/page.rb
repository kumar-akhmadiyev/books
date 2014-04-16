class Page
	include Mongoid::Document

	field :numb, type:Integer
	field :text, type:String, default: ""

	belongs_to :parsed_book
end