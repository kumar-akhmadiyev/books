class ParsedBook
	include Mongoid::Document

	belongs_to :book
	has_many :pages

	def add_section section
		number = self.pages.count + 1
		text = ""
		title = section.xpath("title")[0]
		if (!title.nil?)
		text = "<b>" + section.xpath("title")[0].content + "</b>"
		text += "\n"
		end
		section.xpath("p").each do |p|
			tmp = text + p.content + "\n"
			if (tmp.length <=2100)
				text = tmp
			else
				p = Page.new
				p.text = text
				p.numb = number
				p.parsed_book = self
				p.save!
				number += 1
				text = ""

			end
		end
		if (text != "")
			p = Page.new
			p.text = text
			p.numb = number
			p.parsed_book = self
			p.save!
			number += 1
			text = ""
		end
	end
end

# 34 строки
# 2100 