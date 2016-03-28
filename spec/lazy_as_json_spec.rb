require 'spec_helper'

describe LazyAsJson do
  it 'has a version number' do
    expect(LazyAsJson::VERSION).not_to be nil
  end

  let(:user) { create_user_with_companies }

  context 'with only_keys is set' do
    subject { user.as_json(only_keys: '_,first_name,companies(c),c.name,c.location') }

    it 'has only the specified keys' do
      expect(subject.keys.sort).to be == [:companies, :first_name, :id]
      expect(subject[:companies].map(&:keys).flatten.uniq.sort).to be == [:location, :name]
    end

    it { is_expected.to include(first_name: 'First name') }
    it { is_expected.to include(id: 1) }
    it { is_expected.not_to include(:last_name, :email) }

    it { is_expected.to include(companies: [{name: 'Hello Company1 from Delaware', location: 'Delaware'},
                                            {name: 'Hello Company2 from New York', location: 'New York'}]) }
    it { is_expected.not_to include [companies: [[:address], [:address]]] }
  end

  context 'without only_keys' do
    subject { user.as_json }

    it 'returns only id' do
      expect(subject.keys.sort).to be == [:id]
    end
  end
end
