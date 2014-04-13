class Subgenre
	include Mongoid::Document

	mount_uploader :subgenre, SubgenreUploader
	attr_accessible :subgenre,:subgenre_cache

	field :title, type: String, default: ""

	has_many :books
	belongs_to :genre

end