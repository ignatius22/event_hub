module PagyHelper
  include Pagy::Frontend

  def pagy_nav(pagy)
    return "" if pagy.pages == 1

    html = +'<nav class="flex items-center justify-between border-t border-gray-200 px-4 sm:px-0">'
    html << '<div class="-mt-px flex w-0 flex-1">'

    if pagy.prev
      html << link_to(pagy_url_for(pagy, pagy.prev), class: "inline-flex items-center border-t-2 border-transparent pt-4 pr-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700") do
        '<svg class="mr-3 h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z" clip-rule="evenodd" />
        </svg>
        Previous'.html_safe
      end
    end

    html << '</div><div class="hidden md:-mt-px md:flex">'

    pagy.series.each do |item|
      if item.is_a?(Integer)
        if item == pagy.page
          html << link_to(item, pagy_url_for(pagy, item), class: "inline-flex items-center border-t-2 border-indigo-500 px-4 pt-4 text-sm font-medium text-indigo-600")
        else
          html << link_to(item, pagy_url_for(pagy, item), class: "inline-flex items-center border-t-2 border-transparent px-4 pt-4 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700")
        end
      elsif item == :gap
        html << '<span class="inline-flex items-center border-t-2 border-transparent px-4 pt-4 text-sm font-medium text-gray-500">...</span>'
      end
    end

    html << '</div><div class="-mt-px flex w-0 flex-1 justify-end">'

    if pagy.next
      html << link_to(pagy_url_for(pagy, pagy.next), class: "inline-flex items-center border-t-2 border-transparent pt-4 pl-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700") do
        'Next
        <svg class="ml-3 h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
        </svg>'.html_safe
      end
    end

    html << '</div></nav>'
    html.html_safe
  end
end
