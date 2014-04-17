class Book
	include Mongoid::Document
	include Mongoid::Timestamps

	mount_uploader :bookcover, BookcoverUploader
	mount_uploader :bookfile, BookfileUploader
	attr_accessible :bookcover, :bookcover_cache, :bookfile, :bookfile_cache

	field :title, type: String, default: ""
	field :description, type: String, default: ""
	field :year, type: Integer
	field :average_rating, type: Float, default: 0
	field :views, type: Integer, default: 0

	has_one :parsed_book
	has_many :rates
	belongs_to :subgenre
	belongs_to :author

	def compute_rating
		if self.rates.count == 0
			return
		end
		sum = 0
		self.rates.each do |r|
			sum = sum + r.points
		end
		self.average_rating =  sum / (self.rates.count*1.0)
		self.save!
	end

	def plus_view
		self.views += 1
		self.save!
	end

	def short_description
		if description.length > 80
			return self.description[0,80] + "..."
		else
			return description
		end
	end
end