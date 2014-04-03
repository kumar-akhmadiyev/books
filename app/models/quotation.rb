class Quotation
	include Mongoid::Document

	field :body, type: String, default: ""
	field :author, type: String, default: ""
end