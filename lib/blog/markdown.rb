require 'html/pipeline'
Pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter
  # HTML::Pipeline::SyntaxHighlightFilter
]

module Blog
	class Markdown
		class << self
			def call(body)
		        result = Pipeline.call(body)[:output]
		        # result.strip!
		        # result
			end
		end
	end

end