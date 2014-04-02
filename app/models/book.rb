class Book
	include Mongoid::Document
	include Mongoid::Timestamps

	mount_uploader :bookcover, BookcoverUploader
	mount_uploader :bookfile, BookfileUploader
	attr_accessible :bookcover, :bookcover_cache, :bookfile, :bookfile_cache

	field :title, type: String, default: ""
	field :description, type: String, default: ""
	field :views, type: Integer, default: 0

	has_many :rates
	belongs_to :genre

	def average_rate
		sum = 0
		self.rates.inject{|x| sum + x }
		return sum / self.rates.count
	end

	def short_description
		if description.length > 80
			return self.description[0,80] + "..."
		else
			return description
		end
	end
end