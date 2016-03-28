require_relative 'models'

module LazyAsJsonFactories
  def create_user_with_companies
    ::User.new(
        id:         1,
        first_name: 'First name',
        last_name:  'Last name',
        email:      'abc@def.com',
        companies:  [Company.new(id: 1, name: 'Hello Company1 from Delaware', location: 'Delaware', address: 'Some address'),
                     Company.new(id: 2, name: 'Hello Company2 from New York', location: 'New York', address: '404 5th ave')]
    )
  end
end