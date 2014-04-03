module ApplicationHelper
	def quotation
		return Quotation.all.sample
		
	end

end
