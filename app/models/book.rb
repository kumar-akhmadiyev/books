class Book
	include Mongoid::Document
	include Mongoid::Timestamps

	mount_uploader :bookcover, BookcoverUploader
	mount_uploader :bookfile, BookfileUploader
	attr_accessible :bookcover, :bookcover_cache, :bookfile, :bookfile_cache

	field :title, type: String, default: ""
	field :description, type: String, default: ""
	field :views, type: Integer, default: 0

	has_one :parsed_book
	has_many :rates
	belongs_to :subgenre

	def average_rating
		if self.rates.count == 0
			return 0
		end
		sum = 0
		self.rates.each do |r|
			sum = sum + r.points
		end
		return sum / (self.rates.count*1.0)
	end

	def short_description
		if description.length > 80
			return self.description[0,80] + "..."
		else
			return description
		end
	end
end