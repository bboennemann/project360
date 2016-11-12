# client
# belongs_to organization
# belongs_to department
# has_one address as billing_address
# has_one address as mailing_address
# has_many projects
# has_one rate_card
rails g scaffold client name:string