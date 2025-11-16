# Pagy initializer
require 'pagy/extras/overflow'
require 'pagy/extras/items'

Pagy::DEFAULT[:items] = 12
Pagy::DEFAULT[:size] = [1, 4, 4, 1]
Pagy::DEFAULT[:overflow] = :last_page
